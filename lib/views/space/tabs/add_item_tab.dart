import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:table_ease/controllers/item/item_controller.dart';
import 'package:table_ease/models/item/category_model.dart';
import 'package:table_ease/models/item/item_model.dart';
import 'package:table_ease/utils/colors.dart';
import 'package:table_ease/utils/fonts.dart';
import 'package:table_ease/utils/messenger.dart';

class AddItemTab extends StatefulWidget {
  AddItemTab({required this.spaceId, Key? key}) : super(key: key);

  int spaceId;

  @override
  State<AddItemTab> createState() => _AddItemTabState();
}

class _AddItemTabState extends State<AddItemTab> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String itemKey;

  final _formKey = GlobalKey<FormState>();

  Category? _selectedCategory;

  bool isLoading = false;

  final _descriptionController = TextEditingController();
  final _itemController = TextEditingController();
  final _userController = TextEditingController();
  final _idController = TextEditingController();

  final _priceController = MoneyMaskedTextController(
    leftSymbol: 'R\$',
    decimalSeparator: ',',
    thousandSeparator: '.',
    initialValue: 0,
  );

  double convertToDouble(MoneyMaskedTextController controller) {
    final stringValue = controller.text
        .replaceAll(',', '.')
        .replaceAll('.', '')
        .replaceAll('R\$', '');
    return double.parse(stringValue);
  }

  final List<Category> _categories = [
    Category(
      name: 'Entradas',
      icon: Icons.fastfood,
    ),
    Category(
      name: 'Prato Principal',
      icon: Icons.restaurant,
    ),
    Category(
      name: 'Sobremesas',
      icon: Icons.cake,
    ),
    Category(
      name: 'Bebidas',
      icon: Icons.local_drink,
    ),
    Category(
      name: 'Outro',
      icon: Icons.add,
    )
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _itemController.dispose();
    _userController.dispose();
    _idController.dispose();
    _priceController.dispose();
    // databaseReference.child("salas").child("${widget.roomPassword}").child("users").child(auth.currentUser!.uid).remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Adicionar um novo item",
                      style: AppFonts.text.headlineMedium,
                    ),
                    SizedBox(
                      width: 220,
                      child: TextFormField(
                        controller: _itemController,
                        decoration: const InputDecoration(
                          labelText: 'Descrição (opcional)',
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: AppColors.gray50,
                        width: 1,
                      ))),
                      width: 220,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Category>(
                          icon: _selectedCategory == null
                              ? const Icon(Icons.emoji_food_beverage)
                              : null,
                          value: _selectedCategory,
                          hint: const Text('Categoria'),
                          onChanged: (Category? value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          items: _categories.map((category) {
                            return DropdownMenuItem<Category>(
                              value: category,
                              child: Row(
                                children: [
                                  Icon(category.icon),
                                  const SizedBox(width: 10),
                                  Text(category.name),
                                  const SizedBox(
                                    width: 40,
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLengthEnforcement: MaxLengthEnforcement.none,
                        controller: _priceController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Valor',
                          icon: const Icon(Icons.monetization_on),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _priceController.text = MoneyFormatter(
                                amount: 0,
                                settings: MoneyFormatterSettings(),
                              ).output.nonSymbol;
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 220,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dono do pedido:",
                            style: GoogleFonts.roboto(color: Colors.grey),
                          ),
                          Text(
                            "${auth.currentUser!.displayName}",
                            style:
                                GoogleFonts.roboto(fontWeight: FontWeight.w900),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      width: 220,
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                if (_formKey.currentState!.validate()) {
                                  bool hasValue =
                                      convertToDouble(_priceController) != 0;
                                  if (hasValue) {
                                    try {
                                      double orderPrice =
                                          convertToDouble(_priceController);
                                      await ItemController()
                                          .addItem(
                                              widget.spaceId.toString(),
                                              Item(
                                                  // Space Code
                                                  widget.spaceId.toString(),
                                                  // Description
                                                  _itemController.text,
                                                  // Price
                                                  orderPrice,
                                                  // Category
                                                  _selectedCategory!.name,
                                                  // Icon
                                                  _selectedCategory!
                                                      .icon.codePoint
                                                      .toString(),
                                                  // User id
                                                  _idController.text,
                                                  // User name
                                                  _userController.text,
                                                  // Created time
                                                  DateTime.now()))
                                          .timeout(
                                            const Duration(seconds: 5),
                                          );
                                      setState(() {
                                        isLoading = false;
                                        _selectedCategory = null;
                                        FocusScope.of(context).unfocus();
                                      });
                                      _itemController.clear();
                                      _priceController.text = MoneyFormatter(
                                        amount: 0,
                                        settings: MoneyFormatterSettings(),
                                      ).output.nonSymbol;
                                      if (context.mounted) {
                                        Messenger.showMessage(
                                          context,
                                          "Item criado com sucesso",
                                          AppColors.success,
                                        );
                                      }
                                    } catch (e) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      if (_selectedCategory == null) {
                                        Messenger.showMessage(
                                          context,
                                          "Você deve selecionar uma categoria",
                                          AppColors.error,
                                        );
                                      } else {
                                        Messenger.showMessage(
                                          context,
                                          "Erro ao criar o item",
                                          AppColors.error,
                                        );
                                      }
                                    }
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Messenger.showMessage(
                                      context,
                                      "Você deve selecionar um valor",
                                      AppColors.error,
                                    );
                                  }
                                }
                              },
                              child: const Icon(
                                Icons.add,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
