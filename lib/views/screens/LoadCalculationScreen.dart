import 'package:flutter/material.dart';
import 'package:mymikano_app/State/LoadCalculationState.dart';
import 'package:mymikano_app/models/LoadCalculationModels/EquipmentModel.dart';
import 'package:mymikano_app/models/StoreModels/ProductCategory.dart';
import 'package:mymikano_app/models/StoreModels/ProductModel.dart';
import 'package:mymikano_app/views/screens/ListPage.dart';
import 'package:mymikano_app/views/widgets/T13Widget.dart';
import 'package:mymikano_app/views/widgets/TopRowBar.dart';
import 'package:mymikano_app/views/widgets/itemElement.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class LoadCalculationScreen extends StatefulWidget {
  const LoadCalculationScreen({ Key? key }) : super(key: key);

  @override
  State<LoadCalculationScreen> createState() => _LoadCalculationScreenState();
}

class _LoadCalculationScreenState extends State<LoadCalculationScreen> {
  TextEditingController utilsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<LoadCalculationState>(context, listen: false).clear();
    Provider.of<LoadCalculationState>(context, listen: false).fetchAllComponents();
    utilsController.text = Provider.of<LoadCalculationState>(context, listen: false).utils().toString();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<LoadCalculationState>(
      builder: (context, loadCalculationState, child) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              children: [
                TopRowBar(title: 'Load Calculation'),
                Expanded(
                  child: loadCalculationState.getFieldsCount()!=0?ListView.builder(
                    itemCount: loadCalculationState.getFieldsCount(),
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: DropdownButton<Equipment>(
                                value: loadCalculationState.getcomponents(index),
                                isExpanded: true,
                                items: loadCalculationState.allComponents().map((Equipment value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value.name.toString()),
                                    );
                                  }).toList(), 
                                onChanged: (variable){
                                  loadCalculationState.setComponent(index, loadCalculationState.getcomponentByName(variable.toString()));
                                },)),
                            Text(loadCalculationState.getcomponentQuatity(index).toString()),
                            Column(
                              children: [
                                IconButton(
                                  constraints: BoxConstraints.tight(Size(30,30)),
                                  padding: EdgeInsets.zero,
                                  onPressed: (){
                                    loadCalculationState.incrementComponentQuantity(index);
                                  }, 
                                  icon: Icon(Icons.add)
                                ),
                                IconButton(
                                  constraints: BoxConstraints.tight(Size(30,30)),
                                  padding: EdgeInsets.zero,
                                  onPressed: (){
                                    loadCalculationState.decrementComponentQuantity(index);
                                  }, 
                                  icon: Icon(Icons.minimize))
                              ],
                            )
                          ],
                        ),
                      );
                    }
                  ):Container(),
                ),
                SizedBox(height: 10),
                IconButton(onPressed: (){
                  loadCalculationState.incrementFieldsCount();
                }, icon: Icon(Icons.add_circle, color: Colors.red,)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Utils: ${loadCalculationState.utils()}',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                    Column(
                              children: [
                                IconButton(
                                  constraints: BoxConstraints.tight(Size(30,30)),
                                  padding: EdgeInsets.zero,
                                  onPressed: (){
                                    loadCalculationState.increaseUtils();
                                  }, 
                                  icon: Icon(Icons.add)
                                ),
                                IconButton(
                                  constraints: BoxConstraints.tight(Size(30,30)),
                                  padding: EdgeInsets.zero,
                                  onPressed: (){
                                    loadCalculationState.decreaseUtils();
                                  }, 
                                  icon: Icon(Icons.minimize))
                              ],
                            )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Running Power: ${loadCalculationState.getrunningPower()} KVA",
                    style: TextStyle(color: Colors.grey, fontSize: 22),),
                  ],
                ),
                Row(
                  children: [
                    Text("Starting Power: ${loadCalculationState.getstartingPower()} KVA",
                    style: TextStyle(color: Colors.grey, fontSize: 22),),
                  ],
                ),
                Row(
                  children: [
                    Text("KVA: ${loadCalculationState.KVA()}",
                    style: TextStyle(color: Colors.grey, fontSize: 22),),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: T13Button(textContent: "Find My Generator", onPressed: () async{
                    if(loadCalculationState.getComponentListLength()!=0){
                      List<ProductCategory> list = await loadCalculationState.getResult();
                      Navigator.of(context).push(MaterialPageRoute(builder: ((context) => ListPage(title: list.first.name.toString(), IsCategory: true, categoryID: list.first.id!.toInt(),))));
                    } else {
                      toast('You need to add components');
                    }
                  }))
              ],
            ),
          )
        ),
      ),
    );
  }
}