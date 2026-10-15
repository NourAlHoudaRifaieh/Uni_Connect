import 'package:flutter/material.dart';
import 'package:uni_connect/core/models/user_model.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';

class SeeAnotherSubjectButton extends StatelessWidget {
  final UserModel user;
  SeeAnotherSubjectButton({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: double.infinity,
      child: CustomElevatedButton(
          text: 'See Another Subject',
          type: ButtonType.outlined,
          height: 48,
          borderRadius: 14,
          onPressed: (){
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24))
                ),
                builder: (context) {
                 return SeeAnotherSubjectSheet(user:user);
                }
            );
          }
      ),
    );
  }
}
