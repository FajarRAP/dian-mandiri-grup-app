String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Harap Isi Email';
  }

  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Format Email Tidak Valid';
  }

  return null;
}

String? inputValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Harap Isi';
  }
  return null;
}

String? dropdownValidator(dynamic value) {
  if (value == 0) {
    return 'Harap Isi';
  }

  return null;
}

String? tokenValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Harap Isi Kode Reset';
  }

  final RegExp tokenRegex = RegExp(r'^\d{6}$');
  if (!tokenRegex.hasMatch(value)) {
    return 'Kode reset harus terdiri dari 6 angka';
  }

  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Harap Isi Password';
  }

  if (value.length < 6) {
    return 'Password harus terdiri dari minimal 6 karakter';
  }

  final RegExp passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
  if (!passwordRegex.hasMatch(value)) {
    return 'Password harus terdiri dari huruf besar, huruf kecil, angka, dan karakter spesial';
  }

  return null;
}
