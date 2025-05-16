import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/inputs.dart';
import 'package:fit_quest/model/user.dart';
import 'package:fit_quest/pages/errorPage.dart';
import 'package:fit_quest/pages/profile/components.dart';
import 'package:fit_quest/services/auth.dart';
import 'package:fit_quest/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final Function changeEdit;
  const EditProfile({Key? key, required this.changeEdit}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  String error = '';

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty values
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _initializeControllers(UserData userData) {
    // Update controller values when userData changes
    _nameController.text = userData.name;
    _ageController.text = userData.age.toString();
    _weightController.text = userData.weight.toString();
    _heightController.text = userData.height.toString();
  }

  Widget form(UserData user) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 10,
        children: [
          TextFormField(
            controller: _nameController,
            validator: Validators.text,
            style: TextStyle(fontSize: 12),
            decoration: Inputs.inputDecoration("Name", Icons.person),
          ),
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: Validators.positiveInt,
            style: TextStyle(fontSize: 12),
            decoration: Inputs.inputDecoration("Age", Icons.cake),
          ),
          TextFormField(
            controller: _weightController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: Validators.positiveDouble,
            style: TextStyle(fontSize: 12),
            decoration: Inputs.inputDecoration(
              "Weight (kg)",
              Icons.line_weight,
            ),
          ),
          TextFormField(
            controller: _heightController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: Validators.positiveDouble,
            style: TextStyle(fontSize: 12),
            decoration: Inputs.inputDecoration("Height (cm)", Icons.height),
          ),
        ],
      ),
    );
  }

  Future<void> _updateUserData(UserData originalData) async {
    final updatedData = UserData(
      uid: originalData.uid,
      name: _nameController.text,
      age: int.parse(_ageController.text),
      weight: double.parse(_weightController.text),
      height: double.parse(_heightController.text),
      profilePic: originalData.profilePic,
      lvl: originalData.lvl,
      exp: originalData.exp,
      health: originalData.health,
      attributes: originalData.attributes,
      badges: originalData.badges,
    );

    try {
      await DatabaseService(uid: originalData.uid).setUserData(updatedData);
      widget.changeEdit();
    } catch (e) {
      setState(() => error = 'Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FitUser?>(context);
    if (user == null) return ErrorPage(errorDetail: "User not authenticated");

    return StreamBuilder<UserData?>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return ErrorPage(errorDetail: snapshot.error.toString());
        if (!snapshot.hasData) return CircularProgressIndicator();

        final userData = snapshot.data!;
        _initializeControllers(userData);

        return Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Edit Profile", style: TextStyle(fontSize: 24)),
            form(userData),
            Inputs.formButton(
              state: _formKey.currentState,
              backgroundColor: UI.primary,
              onPressed: () => _updateUserData(userData),
              text: "Save Changes",
              textColor: Colors.white,
            ),
            if (error.isNotEmpty)
              Text(error, style: TextStyle(color: Colors.red)),
          ],
        );
      },
    );
  }
}
