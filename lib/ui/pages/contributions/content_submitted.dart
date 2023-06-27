import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ContentSubmitted extends StatelessWidget {
  const ContentSubmitted({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor= Color(0xff3B4C54);
    const gradientColor=[
      Color(0xFF2686FF),
      Color(0xff2686FF),
      Color(0xff26B0FF)

    ];
    return  Scaffold(
      backgroundColor:backgroundColor ,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/freelancer.svg'),
              const SizedBox(height: 40,),
              const Text("Content Submitted Successfully",textAlign: TextAlign.center,style:TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.w600,),),
              const SizedBox(height: 20,),
              const Text("Our experts will examine your content. An email will be delivered to you shortly. Thank you",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w400),),
              const Text("\nThank you",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w400),),
              const SizedBox(height: 98,),
              Container(
                width: 282,
                height: 53,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(colors: gradientColor,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight
                  ),
                ),
                child: const Center(child: Text("Continue",style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.w400,color: Colors.white,),)),)
            ],
          ),
        ),
      ),
    );
  }
}