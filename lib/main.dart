import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bantu Rakyat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WizardScreen(),
    );
  }
}

class WizardScreen extends StatefulWidget {
  @override
  _WizardScreenState createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Form data
  String namaDepan = '';
  String namaBelakang = '';
  String biodata = '';
  String provinsi = '';
  String kota = '';
  String kecamatan = '';
  String desa = '';

  // Photo data
  XFile? fotoSelfie;
  XFile? fotoKTP;
  XFile? fotoBebas;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Bantu Rakyat'),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            if (_currentStep == 0 && _validateStep1()) {
              setState(() {
                _currentStep += 1;
              });
            } else if (_currentStep == 1 && _validateStep2()) {
              setState(() {
                _currentStep += 1;
              });
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: Text('Informasi Pribadi'),
            content: _buildWizard1(),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: Text('Foto'),
            content: _buildWizard2(),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: Text('Tinjauan'),
            content: _buildReview(),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }

  bool _validateStep1() {
    if (_formKey.currentState!.validate()) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mohon lengkapi semua field')),
      );
      return false;
    }
  }

  bool _validateStep2() {
    if (fotoSelfie == null || fotoKTP == null || fotoBebas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mohon unggah semua foto yang diperlukan')),
      );
      return false;
    }
    return true;
  }

  Widget _buildWizard1() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nama Depan',
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (value) => setState(() => namaDepan = value),
              validator: (value) => value!.isEmpty ? 'Mohon masukkan nama depan' : null,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nama Belakang',
                prefixIcon: Icon(Icons.person_outline),
              ),
              onChanged: (value) => setState(() => namaBelakang = value),
              validator: (value) => value!.isEmpty ? 'Mohon masukkan nama belakang' : null,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Biodata',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              onChanged: (value) => setState(() => biodata = value),
              validator: (value) => value!.isEmpty ? 'Mohon masukkan biodata' : null,
            ),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSearchBox: true,
              ),
              items: ['Provinsi 1', 'Provinsi 2', 'Provinsi 3'],
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Provinsi",
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),
              onChanged: (value) => setState(() => provinsi = value!),
              validator: (value) => value == null ? 'Mohon pilih provinsi' : null,
            ),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSearchBox: true,
              ),
              items: ['Kota 1', 'Kota 2', 'Kota 3'],
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Kota",
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              onChanged: (value) => setState(() => kota = value!),
              validator: (value) => value == null ? 'Mohon pilih kota' : null,
            ),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSearchBox: true,
              ),
              items: ['Kecamatan 1', 'Kecamatan 2', 'Kecamatan 3'],
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Kecamatan",
                  prefixIcon: Icon(Icons.map),
                ),
              ),
              onChanged: (value) => setState(() => kecamatan = value!),
              validator: (value) => value == null ? 'Mohon pilih kecamatan' : null,
            ),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSearchBox: true,
              ),
              items: ['Desa 1', 'Desa 2', 'Desa 3'],
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Desa",
                  prefixIcon: Icon(Icons.home),
                ),
              ),
              onChanged: (value) => setState(() => desa = value!),
              validator: (value) => value == null ? 'Mohon pilih desa' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWizard2() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPhotoUpload('Foto Selfie', fotoSelfie, (value) => setState(() => fotoSelfie = value), true),
          _buildPhotoUpload('Foto KTP', fotoKTP, (value) => setState(() => fotoKTP = value), false),
          _buildPhotoUpload('Foto Bebas', fotoBebas, (value) => setState(() => fotoBebas = value), false),
        ],
      ),
    );
  }

  Widget _buildPhotoUpload(String title, XFile? photo, Function(XFile?) onPhotoChanged, bool isSelfie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        photo != null
            ? GestureDetector(
                onTap: () => _showPhotoPreview(photo),
                child: Image.file(File(photo.path), height: 150),
              )
            : Container(
                height: 150,
                color: Colors.grey[300],
                child: Center(child: Text('Belum ada foto')),
              ),
        SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                XFile? image;
                if (isSelfie) {
                  image = await _picker.pickImage(source: ImageSource.camera);
                } else {
                  image = await _picker.pickImage(source: ImageSource.gallery);
                }
                if (image != null) {
                  onPhotoChanged(image);
                }
              },
              icon: Icon(isSelfie ? Icons.camera_alt : Icons.photo_library),
              label: Text(photo != null ? 'Unggah Ulang' : 'Unggah'),
            ),
            if (photo != null)
              TextButton.icon(
                onPressed: () => onPhotoChanged(null),
                icon: Icon(Icons.delete),
                label: Text('Hapus'),
              ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  void _showPhotoPreview(XFile photo) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: Text('Pratinjau Foto')),
        body: PhotoView(
          imageProvider: FileImage(File(photo.path)),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ),
    ));
  }

  Widget _buildReview() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Pribadi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Nama Depan: $namaDepan'),
          Text('Nama Belakang: $namaBelakang'),
          Text('Biodata: $biodata'),
          Text('Provinsi: $provinsi'),
          Text('Kota: $kota'),
          Text('Kecamatan: $kecamatan'),
          Text('Desa: $desa'),
          SizedBox(height: 16),
          Text('Foto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (fotoSelfie != null) GestureDetector(
            onTap: () => _showPhotoPreview(fotoSelfie!),
            child: Image.file(File(fotoSelfie!.path), height: 100),
          ),
          if (fotoKTP != null) GestureDetector(
            onTap: () => _showPhotoPreview(fotoKTP!),
            child: Image.file(File(fotoKTP!.path), height: 100),
          ),
          if (fotoBebas != null) GestureDetector(
            onTap: () => _showPhotoPreview(fotoBebas!),
            child: Image.file(File(fotoBebas!.path), height: 100),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate() && _validateStep2()) {
                // Implement submit logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Formulir berhasil dikirim!')),
                );
              }
            },
            icon: Icon(Icons.send),
            label: Text('Kirim'),
          ),
        ],
      ),
    );
  }
}
