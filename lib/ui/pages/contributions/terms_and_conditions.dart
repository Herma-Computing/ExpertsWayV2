import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {

    const backgroundColor= Color(0xff3B4C54);
    const gradientColor=[
      Color(0xFF2686FF),
      Color(0xff2686FF),
      Color(0xff26B0FF)

    ];
    return  Scaffold(

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent ,elevation: 0, leading: IconButton(onPressed: ()=>{},icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
      ),
        title: const Text("Edit Lesson",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),
      ),
      backgroundColor:backgroundColor ,
      body: Container(
        padding: const EdgeInsets.all(30),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          //  crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Padding(
              padding: const EdgeInsets.only(top:58.0),
              child: SvgPicture.asset('assets/images/freelancer.svg'),
            )),
            const SizedBox(height: 40,),
            const Center(child: Text("Terms and Conditions",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),)),
            const SizedBox(height: 38,),
            Padding(
              padding: const EdgeInsets.only(bottom: 34),
              child: termsText('1. There must to be sufficient detail in the content. To make the lesson content easier for readers to understand, please provide more descriptions.'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:32),
              child: termsText('2. The lesson material should not contain any contact hashtags or lengthy descriptions unless absolutely essential'),
            ),
            Padding(
              padding: const EdgeInsets.only( bottom: 34),
              child: termsText('3.Avoid misspellings and ambiguous information.'),
            ),
            Padding(
              padding: const EdgeInsets.only (bottom:20.0),
              child: termsText('4. Must follow proper formatting'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  shape:const CircleBorder(),
                  focusColor: Colors.greenAccent,
                  hoverColor: Colors.greenAccent,
                  onChanged: (bool? value) {  }, value: true,
                ),
                termsText("Accept terms and Condtions")
              ],
            ),
            const SizedBox(height: 98,),
            Center(
              child: Container(
                width: 282,
                height: 53,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(colors: gradientColor,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight
                  ),
                ),
                child: const Center(child: Text("Accept & Continue",style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.w400,color: Colors.white,),)),),
            )
          ],
        ),
      ),
    );
  }

  Text termsText(String text) => Text(text,style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400),);
}