import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon_app/objects/api.dart';
import 'package:hackathon_app/objects/product.dart';
import 'package:hackathon_app/objects/prefs_object.dart';

import '../objects/ProductVariant.dart';
import '../responses/fetch_building_response.dart';
import '../responses/fetch_buildings_response.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = 'addProductScreen';
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  VariantFieldsState variantFieldsState = VariantFieldsState();
  ProductFieldsState productFieldsState = ProductFieldsState();
  var variantNameController = TextEditingController();
  var variantPriceController = TextEditingController();
  var variantCountController = TextEditingController();
  List<Building>? buildings;
  List<Floor>? currentlyAvailableFloors;
  List<ProductVariant> variants = [];

  @override
  Widget build(BuildContext context) {
    if (buildings == null) {
      _fetchBuildings();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Přidat boty"),
      ),
      // Create a form with a text field for the product name and description.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
            children: [
              const SizedBox(height: 10),
              _buildGeneralInfoSection(),
              const SizedBox(height: 30),
              _buildVariantsSection(),
              const SizedBox(height: 30),
              _buildCreatedVariantSection(),
              const SizedBox(height: 120),
              // Create Elevated button to submit the form.
              _buildSubmitButton()
            ]
        ),
      ),
    );
  }

  void _fetchBuildings() {
    buildings = [];
    Api.getBuildings().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          buildings = response.data!.buildings;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Nastala chyba při získávání skladů. Chyba:" + response.message)
          ),
        );
        Navigator.pop(context);
        return;
      }
    });
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: 120,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          _submitProduct();
        },
        child: const Text('Přidat'),
      ),
    );
  }

  Future<void> _submitProduct() async {
    if (productFieldsState.isAnyNull()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vyplňte všechny obecné informace o botách."),
        ),
      );
      return;
    }

    if (variants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Musíte přidat alespoň jednu variantu."),
        ),
      );
      return;
    }

    Product product = Product(
      name: productFieldsState.name!,
      description: productFieldsState.description!,
      variants: variants,
    );

    Api.createProduct(product, (await PrefsObject.getToken())!)
    .then((createProductResponse) async => {
      if (createProductResponse.statusCode == 200) {
        print("GGGGGGGG ${productFieldsState.selectedFloor!.content.id}"),
        Api.addProductToWarehouse(
            createProductResponse.data!.product.id,
            productFieldsState.selectedFloor!.content.id,
            (await PrefsObject.getToken())!)
            .then((response) {
              if (response.statusCode == 200) {
                PrefsObject.addRecentProduct(createProductResponse.data!.product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Boty byly úspěšně přidány."),
                  ),
                );
                Navigator.pop(context);
                return;
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Něco se pokazilo při ukládání do skladu. Chyba: ${response.message}"),
                  ),
                );
              }
            })
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Něco se pokazilo při ukládání bot. Chyba: ${createProductResponse.message}"),
          ),
        )
      }
    });
  }

  Widget _buildVariantsSection() {
    return Column(
      children: [
        const Text(
          "Varianty",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 25),
        _buildCreateVariantFields(),
        const SizedBox(height: 10),
        IconButton(
          iconSize: 35.0,
          icon: const Icon(Icons.add),
          onPressed: () {_addVariant();},
        ),
      ],
    );
  }

  void _addVariant() {
    if (variantFieldsState.isAnyNull()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nejprve vyplňte všechna pole varianty"),
        ),
      );
      return;
    }

    ProductVariant variant = ProductVariant(
      name: variantFieldsState.name!,
      price: variantFieldsState.price!,
      count: variantFieldsState.count,
    );

    setState(() {
      variants.add(variant);
      variantFieldsState.reset();
      variantNameController.clear();
      variantPriceController.clear();
      variantCountController.clear();
    });
  }

  Widget _buildCreateVariantFields() {
    return Column(
      children: [
        _buildTextField("Název varianty", (text) => variantFieldsState.name = text, controller: variantNameController),
        const SizedBox(height: 10),
        _buildNumberField("Cena", (number) => variantFieldsState.price = number, controller: variantPriceController),
        const SizedBox(height: 10),
        _buildNumberField("Počet kusů", (number) => variantFieldsState.count = number, controller: variantCountController),
      ],
    );
  }

  Widget _buildCreatedVariantSection() {
    return Column(
      children: [
        const Text(
          "Hotové varianty",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 25),
        _buildCreatedVariantList(),
      ],
    );
  }

  Widget _buildCreatedVariantList() {
    List<Card> cards = [];
    for (int i = 0; i < variants.length; ++i) {
      cards.add(_buildCreatedVariantCard(variants[i]));
    }
    return Column(
      children: cards,
    );
  }

  Card _buildCreatedVariantCard(ProductVariant variant) {
    return Card(
      child: ListTile(
        title: Text(variant.name),
        subtitle: Text("${variant.price} Kč"),
        trailing: Text("${variant.count} ks"),
      ),
    );
  }

  Column _buildGeneralInfoSection() {
    return Column(
        children: [
          const Text(
            "Obecné informace",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          _buildTextField("Název", (text) => productFieldsState.name = text),
          const SizedBox(height: 10),
          _buildTextField("Popis", (text) => productFieldsState.description = text),
          const SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBuildingsDropdown(),
              const SizedBox(width: 30),
              FloorsDropdown(floors: currentlyAvailableFloors, onFloorSelected: (floor) {
                setState(() {
                  productFieldsState.selectedFloor = floor;
                });
              }),
            ]
          )
        ]
    );
  }

  Widget _buildBuildingsDropdown() {
    return BuildingsDropdown(
      buildings: buildings!,
      onBuildingSelected: (building) async {
        setState(() {
          productFieldsState.selectedBuilding = building;
          productFieldsState.selectedFloor = null;
          currentlyAvailableFloors = null;
        });
        Api.getBuilding(building.id, (await PrefsObject.getToken())!).then((response) {
          setState(() {
            currentlyAvailableFloors = response.data!.building.floors.where((floor) {
              return floor.type == "Warehouse";
            }).toList();
          });
        });
      },
    );
  }

  TextField _buildNumberField(String label, Function(int) onChanged,  {TextEditingController? controller}) {
    return TextField(
      controller: controller,
      onChanged: (text) => onChanged(int.parse(text)),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }

  TextField _buildTextField(String label, Function(String) onChanged, {TextEditingController? controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      onChanged: onChanged,
    );
  }
}

class VariantFieldsState {
  String? name;
  int? price;
  int count = 0;

  void reset() {
    name = null;
    price = null;
    count = 0;
  }

  bool isAnyNull() {
    return name == null || price == null;
  }
}

class ProductFieldsState {
  String? name;
  String? description;
  Building? selectedBuilding;
  Floor? selectedFloor;

  bool isAnyNull() {
    return name == null || description == null || selectedBuilding == null || selectedFloor == null;
  }
}

class BuildingsDropdown extends StatefulWidget {
  final List<Building> buildings;
  final Function(Building) onBuildingSelected;

  const BuildingsDropdown({Key? key, required this.buildings, required this.onBuildingSelected}) : super(key: key);

  @override
  State<BuildingsDropdown> createState() => _BuildingsDropdownState();
}

class _BuildingsDropdownState extends State<BuildingsDropdown> {
  String? selectedValue;

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [];
    for (Building building in widget.buildings) {
      menuItems.add(DropdownMenuItem(value: building.id, child: Text(building.name)));
    }
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      hint: const Text("Sklad"),
      value: selectedValue,
      items: dropdownItems,
      onChanged: (String? value) {
        selectedValue = value!;
        Building building = widget.buildings.firstWhere((build) => build.id == value);
        widget.onBuildingSelected(building);
      },
    );
  }
}




class FloorsDropdown extends StatefulWidget {
  final List<Floor>? floors;
  final Function(Floor) onFloorSelected;

  const FloorsDropdown({Key? key, this.floors, required this.onFloorSelected}) : super(key: key);

  @override
  State<FloorsDropdown> createState() => _FloorsDropdownState();
}

class _FloorsDropdownState extends State<FloorsDropdown> {
  String? selectedFloorId;

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [];
    for (Floor floor in widget.floors ?? []) {
      menuItems.add(DropdownMenuItem(value: floor.id, child: Text(floor.content!.name)));
    }
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      hint: const Text("Patro"),
      value: selectedFloorId,
      items: dropdownItems,
      onChanged: (String? value) {
        selectedFloorId = value!;
        Floor floor = widget.floors!.firstWhere((f) => f.id == value);
        widget.onFloorSelected(floor);
      },
    );
  }
}