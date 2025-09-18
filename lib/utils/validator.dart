class Validator{

  // E-mail validation

  static String? emailValidation(String? value){
    if(value == null || value.isEmpty){
      return 'E-mail required';
    }if(!value. contains('@')){
      return 'Enter a valid email';
    }
    return null;
  }

  // Password Validation

static String? passwordValidation(String? value){

    if(value == null || value.isEmpty){
      return 'Password Required';
    }if(value.length < 8){
      return 'Password must be at least 8 characters';
    }
    return null;
}

}