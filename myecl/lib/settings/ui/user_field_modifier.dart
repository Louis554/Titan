import 'package:flutter/material.dart';

class UserFieldModifier extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final TextEditingController controller;
  const UserFieldModifier(
      {Key? key,
      required this.label,
      required this.keyboardType,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * 0.25,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 158, 158, 158),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 158, 158, 158),
                  ),
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          )
        ],
      ),
    );
  }
}