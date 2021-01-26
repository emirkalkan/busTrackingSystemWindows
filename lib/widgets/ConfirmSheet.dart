import 'package:bus_tracking_system/brand_colors.dart';
import 'package:bus_tracking_system/widgets/TaxiOutlineButton.dart';
import 'package:flutter/material.dart';

class ConfirmSheet extends StatelessWidget {

  final String title;
  final String subtitle;
  final Function onPressed;

  ConfirmSheet({this.title, this.subtitle, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0, //soften the shadow
            spreadRadius: 0.5, //extend the shadow
            offset: Offset(
              0.7, //Move to right 10 horizontally
              0.7, //Move to bottom 10 vertically
            ),
          )
        ],

      ),
      height: 220,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: <Widget>[

            SizedBox(height: 10,),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontFamily: 'Brand-Bold', color: BrandColors.colorText),
            ),

            SizedBox(height: 20,),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: BrandColors.colorTextLight),
            ),

            SizedBox(height: 24,),

            Row(
              children: <Widget>[

                Expanded(
                  child: Container(
                    child: TaxiOutlineButton(
                      title: 'BACK',
                      color: BrandColors.colorLightGrayFair,
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),

                SizedBox(width: 16,),

                Expanded(
                  child: Container(
                    child: RaisedButton(
                      onPressed: onPressed,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25)
                      ),
                      color: (title == 'GO ONLINE' ? BrandColors.colorGreen : BrandColors.colorOrange),
                      textColor: Colors.white,
                      child: Container(
                        height: 50,
                        width: 200,
                        child: Center(
                          child: Text(
                            'CONFIRM',
                            style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            )

          ],
        ),
      ),
    );
  }
}
