import 'package:flutter/material.dart';
class MyAppBar extends StatelessWidget implements PreferredSizeWidget
{
  MyAppBar({ Key? key, required this.titulo }) : super(key: key);
  final dynamic titulo;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context)
  {
    return AppBar
    (
      title: Text
      (
        titulo,
      ),
      centerTitle: true,
    );
  }
}