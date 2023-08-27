import 'package:flutter/material.dart';

class AdWidget extends StatelessWidget {
  final Color? backgroundCardColor;
  final Color? btnColor;
  final Color? btnTextColor;
  const AdWidget(
      {this.backgroundCardColor, this.btnColor, this.btnTextColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: backgroundCardColor ?? const Color(0xffF17547)),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bags.png',
              height: 140,
              fit: BoxFit.fill,
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 22, top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          '20% OFF DURING THE WEEKEND',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: btnTextColor ?? Colors.white,
                              fontSize: 17),
                        )),
                        const SizedBox(
                          width: 50,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: btnColor ?? Colors.white),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Get Now',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: btnTextColor ?? Color(0xffF17547)),
                          ),
                        ))
                  ],
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
