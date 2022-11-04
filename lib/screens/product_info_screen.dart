import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon_app/objects/SharedPrefs.dart';
import 'package:hackathon_app/objects/api.dart';
import 'package:hackathon_app/responses/get_product_response.dart';
import 'package:hackathon_app/screens/HomeScreen.dart';
import 'package:selectable_container/selectable_container.dart';

import '../responses/change_variant_count_response.dart';

enum FetchStatus { loading, loaded, error }

class ProductInfoScreen extends StatefulWidget {
  static const String routeName = 'productInfoScreen';

  const ProductInfoScreen({Key? key}) : super(key: key);

  @override
  State<ProductInfoScreen> createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {
  FetchStatus status = FetchStatus.loading;
  ProductData? product;
  // Create a map where the key is number.
  List<Pair> selectedVariants = [];

  @override
  Widget build(BuildContext context) {
    if (status == FetchStatus.loading && product == null) {
      String id = ModalRoute.of(context)!.settings.arguments as String;
      Api.getProduct(id).then((response) {
        print("Original json from product get: ${response.originalJson}");
        if (response.statusCode == 200) {
          product = response.data;
          setState(() => status = FetchStatus.loaded);
        } else {
          setState(() => status = FetchStatus.error);
        }
      });
    }
    if (status == FetchStatus.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (status == FetchStatus.error) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Informace o produktu"),
        ),
        body: const Center(
          child: Text(
            "Chyba při načítání produktu",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Informace o produktu"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text(
              "${product!.name}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product!.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              "Varianty:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            _buildVariants(),
            Expanded(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: _buildIssueButton()),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Issue = vydat.
  Widget _buildIssueButton() {
    return Container(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: selectedVariants.isEmpty ? null : () async {
          setState(() => status = FetchStatus.loading);

          for (var pair in selectedVariants) {
            Variant variant = product!.variants[pair.index];
            ChangeVariantCountResponse response = await Api.changeProductVariantCount(
                variant.id,
                (await PrefsObject.getToken())!,
                product!.variants[pair.index].count - pair.count);

            print("COUNT CHANGE RESPONSE:");
            print(response.originalJson);

            if (response.statusCode == 400) {
              setState(() => status = FetchStatus.loaded);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Nastala chyba při vydávání bot. (${response.message})"),
                ),
              );
              return;
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Boty úspěšně vydány!"),
            ),
          );
          Navigator.pushNamed(context, HomeScreen.routeName);
        },

        child: const Text("Vydat", style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildVariants() {
    return Expanded(
      child: ListView.builder(
        itemCount: product!.variants.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSelectableContainer(index),
                  Visibility(
                    visible: selectedVariants.any((pair) => pair.index == index),
                    child: _buildNumberInput((value) {
                      return selectedVariants.firstWhere((element) => element.index == index).count = value;
                    }, product!.variants[index].count),
                  )
                ],
              )

            ],
          );
        },
      ),
    );
  }

  Widget _buildNumberInput(Function(int) onChanged, int max) {
    return SizedBox(
      width: 50,
      child: TextField(
          inputFormatters: [
            NumericalRangeFormatter(min: 0, max: max)
          ],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'ks',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            onChanged(int.parse(value));
          }
      ),
    );
  }

  Widget _buildSelectableContainer(int index) {
    return SelectableContainer(
      selected: selectedVariants.any((pair) => pair.index == index),
      onValueChanged: (newValue) {
        setState(() {
          newValue
              ? selectedVariants.add(Pair(index, 0))
              : selectedVariants.removeWhere((pair) => pair.index == index);
        });
      },
      padding: 16.0,
      child: Text(
        "${product!.variants[index].name} | ${product!.variants[index].price}Kč | ${product!.variants[index].count}ks",
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}

class Pair {
  int index;
  int count;

  Pair(this.index, this.count);
}

class NumericalRangeFormatter extends TextInputFormatter {
  final int min;
  final int max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {

    if (newValue.text == '') {
      return newValue;
    } else if (int.parse(newValue.text) < min) {
      return const TextEditingValue().copyWith(text: min.toString());
    } else {
      return int.parse(newValue.text) > max ? oldValue : newValue;
    }
  }
}