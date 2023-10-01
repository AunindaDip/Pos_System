import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';


class saleslist extends StatefulWidget {
  const saleslist({super.key});
  @override
  State<saleslist> createState() => _saleslistState();
}

class _saleslistState extends State<saleslist> {
  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref("Sells");

    return Scaffold(
      appBar: AppBar(title: Text("Sell List "),),

      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            Expanded(child: StreamBuilder
              (
              stream: ref.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot)


              {
                if (snapshot.hasData)
                {
                  List<dynamic>sells=[];
                  if(snapshot.data?.snapshot.value!=null)
                  {
                    Map<dynamic,dynamic> map=
                    snapshot.data!.snapshot.value as dynamic;
                    sells = map.values.toList();

                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: sells.length,
                      itemBuilder: (context, int index)
                  {
                    return Padding(padding: EdgeInsets.all(8.0),
                    child: Container(
                      height: 120,
                        width: MediaQuery.of(context).size.width * 0.9, 
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(5.0, 5.0), //(x,y)
                            blurRadius: 8.0,
                          ),
                        ],
                        
                      ),
                      child:Column(
                        children: [
                          Text("Sales Serial "+sells[index]['CustomerName'])

                        ],
                      )
                      
                    ),
                    
                    
                    );
                    
                  }
                  
                  );

                }
                else if(snapshot.hasError)
                {
                  return Text('Error: ${snapshot.error}');
                }




             else{
               return Center(child: CircularProgressIndicator(),);
                } },
            )
              )
          ],
        ),
      ),


    );
  }
}
