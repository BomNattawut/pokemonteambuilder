import 'package:flutter/material.dart';

class Showallproduct extends StatefulWidget {
  const Showallproduct({super.key});

  @override
  State<Showallproduct> createState() => _ShowallproductState();
}

class _ShowallproductState extends State<Showallproduct> {
  List<Map<String,dynamic>> products =[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              ListView.builder(
                itemCount: products.length ,
                itemBuilder: (context,index){
                  final product = products[index];
                  return ListTile(
                    leading:  Image.network(product['iamge']),
                    title: product['name'],
                    subtitle: product['descrip'],
                    onTap: () {
                      
                    },
                    
                    
                    
                  );
              } )
              
            ],
          ),
        ),
    );
}}

