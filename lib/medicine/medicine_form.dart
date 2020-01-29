import 'dart:io';
import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:diabetes_app/medicine/medicine.dart';
import 'package:diabetes_app/medicine/medicine_api.dart';
import 'package:diabetes_app/medicine/medicine_notifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MedicineForm extends StatefulWidget {
  final bool isUpdating;

  MedicineForm({@required this.isUpdating});

  @override
  _MedicineFormState createState() => _MedicineFormState();
}

class _MedicineFormState extends State<MedicineForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Medicine _currentMedicine;
  String _imageUrl;
  File _imageFile;

  @override
  void initState() {
    super.initState();
    MedicineNotifier medicineNotifier =
        Provider.of<MedicineNotifier>(context, listen: false);

    if (medicineNotifier.currentMedicine != null) {
      _currentMedicine = medicineNotifier.currentMedicine;
    } else {
      _currentMedicine = Medicine();
    }
    _imageUrl = _currentMedicine.image;
  }

  Widget _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return SizedBox(
        height: 0,
      );
    } else if (_imageFile != null) {
      print('showing image from local file');
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  _getLocalImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Name',
          hintText: 'eg. Ibuprofen',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          prefixIcon: Icon(Icons.local_hospital)),
      initialValue: _currentMedicine.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentMedicine.name = value;
      },
    );
  }

  Widget _buildCategoryField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Category',
        hintText: 'eg. nonsteroidal anti-inflammatory',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 12.0,
        ),border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          prefixIcon: Icon(Icons.category)
      ),
      initialValue: _currentMedicine.category,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Category is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentMedicine.category = value;
      },
    );
  }

  Widget _buildIntakeField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Intake',
        hintText: 'eg. whenever needed',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 12.0,
        ),border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          prefixIcon: Icon(Icons.timelapse)
      ),
      initialValue: _currentMedicine.intake,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Intake is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentMedicine.intake = value;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Description',
        hintText:
            'eg. Ibuprofen is a medication in the nonsteroidal anti-inflammatory drug class that is used for treating pain, fever, and inflammation. This includes painful menstrual periods, migraines, and rheumatoid arthritis. It may also be used to close a patent ductus arteriosus in a premature baby.',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 12.0,
        ),border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          prefixIcon: Icon(Icons.description)
      ),
      initialValue: _currentMedicine.description,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        return null;
      },
      onSaved: (String value) {
        _currentMedicine.description = value;
      },
    );
  }

  _onMedicineUploaded(Medicine medicine, bool hmm) {
    MedicineNotifier medicineNotifier = Provider.of<MedicineNotifier>(context);
    if (hmm == false) {
      medicineNotifier.addMedicine(medicine);
    }

    Navigator.pop(context);
  }

  _saveMedicine() {
    print('saveMedicine Called');

    if (!_formKey.currentState.validate()) {
      return;
    }
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    _formKey.currentState.save();
    _currentMedicine.user = authNotifier.user.displayName;
    _currentMedicine.userEmail = authNotifier.user.email;
    print('form saved');

    uploadMedicineAndImage(
        _currentMedicine, widget.isUpdating, _imageFile, _onMedicineUploaded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Add/Edit',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 0, left: 32, bottom: 32, right: 32),
        child: Form(
            key: _formKey,
            autovalidate: true,
            child: Column(children: <Widget>[
              _showImage(),
              SizedBox(
                height: 16,
              ),
              Text(
                widget.isUpdating ? "Edit Medicine" : "Add Medicine",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 16,
              ),
              _imageFile == null && _imageUrl == null
                  ? ButtonTheme(
                      child: RaisedButton(
                        onPressed: () => _getLocalImage(),
                        child: Text('Add Image',
                            style: TextStyle(color: Colors.white)),
                      ),
                    )
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(height: 15,),
              _buildNameField(),
              SizedBox(height: 10,),
              _buildCategoryField(),
              SizedBox(height: 10,),
              _buildIntakeField(),
              SizedBox(height: 10,),
              _buildDescriptionField(),
              SizedBox(
                height: 16,
              ),
            ])),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveMedicine(),
        child: Icon(Icons.save),
      ),
    );
  }
}
