import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/helpers/ensure-visible.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';

class ProductEditPage extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'decription': null,
    'price': null,
    'image': 'assets/images/banner03.jpg'
  };
  // String _titleValue;
  // String _descriptionValue;
  // double _priceValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildTitleTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(
          labelText: 'Product Title',
        ),
        initialValue: product == null ? '' : product.title,
        //autovalidate: true, always show error even when input is untouched
        validator: (String value) {
          // if(value.trim().length <= 0){
          if (value.isEmpty || value.length < 5) {
            return 'Title is required & minimum of 5 chars';
          }
        },
        onSaved: (String value) {
          _formData['title'] = value;
        },
      ),
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: 'Product Description',
        ),
        initialValue: product == null ? '' : product.description,
        validator: (String value) {
          // if(value.trim().length <= 0){
          if (value.isEmpty || value.length < 10) {
            return 'description is required & minimum of 10 chars';
          }
        },
        onSaved: (String value) {
          _formData['description'] = value;
        },
      ),
    );
  }

  void _submitForm(Function addProduct, Function updateProduct, Function setSelectedProduct ,[int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == null) {
      addProduct(
          _formData['title'],
           _formData['description'],
          _formData['image'],
          _formData['price']);
    } else {
      updateProduct(
              _formData['title'],
              _formData['description'],
              _formData['image'],
              _formData['price']);
    }

    Navigator.pushReplacementNamed(context, '/products').then((_) => setSelectedProduct(null));
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          child: Text('Save'),
          textColor: Colors.white,
          onPressed: () => _submitForm(model.addProduct,model.updateProduct, model.selectProduct ,model.selectedProductIndex),
        );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 600.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              EnsureVisibleWhenFocused(
                focusNode: _priceFocusNode,
                child: TextFormField(
                  focusNode: _priceFocusNode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Product Price',
                  ),
                  initialValue: product == null
                      ? ''
                      : product.price.toString(),
                  validator: (String value) {
                    // if(value.trim().length <= 0){
                    if (value.isEmpty ||
                        !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$')
                            .hasMatch(value)) {
                      return 'Price is required & and must be a number';
                    }
                  },
                  onSaved: (String value) {
                    _formData['price'] = double.parse(value);
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(),
              //to customize your own button
              // GestureDetector(
              //   onTap: _submitForm,
              //   child: Container(
              //     color: Colors.green,
              //     padding: EdgeInsets.all(5.0),
              //     child: Text('My button'),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent = _buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Product'),
            ),
            body: pageContent,
          );
      },
    ); 
  }
}
