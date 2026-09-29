import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() { runApp(MaterialApp(debugShowCheckedModeBanner: false, home: LanguageScreen())); }

class LanguageScreen extends StatefulWidget { @override _LanguageScreenState createState() => _LanguageScreenState(); }
class _LanguageScreenState extends State<LanguageScreen> {
  String selected = "Hindi";
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Padding(padding: EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 30),
      Center(child: Container(height: 80,width: 80,decoration: BoxDecoration(color: Color(0xFF4F46E5),borderRadius: BorderRadius.circular(20)),child: Center(child: Text("M",style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold))))),
      SizedBox(height: 12), Center(child: Text("Malik Pro",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold))), Center(child: Text("Worker Management",style: TextStyle(color: Colors.grey))),
      SizedBox(height: 30),
      Text("Bhasha Chune",style: TextStyle(fontWeight: FontWeight.bold)),
      Card(child: RadioListTile(value: "Hindi",groupValue: selected,title: Text("Hindi"),onChanged: (v){setState(()=> selected=v.toString());})),
      Card(child: RadioListTile(value: "Gujarati",groupValue: selected,title: Text("Gujarati"),onChanged: (v){setState(()=> selected=v.toString());})),
      Card(child: RadioListTile(value: "English",groupValue: selected,title: Text("English"),onChanged: (v){setState(()=> selected=v.toString());})),
      Spacer(),
      SizedBox(width: double.infinity,height: 52,child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4F46E5),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (c)=> NumberScreen()));},child: Text("Continue",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)))),
    ]))));
  }
}

class NumberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController ctrl = TextEditingController();
    return Scaffold(appBar: AppBar(title: Text("Login")), body: Padding(padding: EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Mobile Number",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)), Text("Secure login",style: TextStyle(color: Colors.grey)),
      SizedBox(height: 20),
      TextField(controller: ctrl,keyboardType: TextInputType.phone,maxLength: 10,inputFormatters: [FilteringTextInputFormatter.digitsOnly],decoration: InputDecoration(prefixText: "+91 ",hintText: "98XXXXXXXX",border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      Spacer(),
      SizedBox(width: double.infinity,height: 52,child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),onPressed: (){
        if(ctrl.text.length!=10){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("10 digit number dalo"))); return; }
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> HomeScreen(mobile: ctrl.text)));
      },child: Text("Continue",style: TextStyle(color: Colors.white)))),
    ])));
  }
}

class HomeScreen extends StatefulWidget { String mobile; HomeScreen({required this.mobile}); @override _HomeScreenState createState() => _HomeScreenState(); }
class _HomeScreenState extends State<HomeScreen> {
  List jobs = [];
  TextEditingController titleC = TextEditingController(); TextEditingController catC = TextEditingController(); TextEditingController locC = TextEditingController(); TextEditingController salC = TextEditingController();
  int worker = 2;

  void addJob(){
    if(titleC.text.trim().length < 3){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Title likho"))); return; }
    if(locC.text.isEmpty || salC.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location & Salary likho"))); return; }
    setState((){
      jobs.insert(0, {"title":titleC.text,"cat":catC.text.isEmpty?"General":catC.text,"worker":worker,"loc":locC.text,"sal":salC.text,"views":0});
      titleC.clear(); catC.clear(); locC.clear(); salC.clear(); worker=2;
    });
  }

  void shareWhatsApp(Map job){
    String text = "🔹 ${job["title"]}\nCategory: ${job["cat"]}\nWorker: ${job["worker"]}\nLocation: ${job["loc"]}\nSalary: Rs ${job["sal"]}\n\nContact: Malik Pro App se";
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied! WhatsApp pe paste karke bhejo")));
  }

  InputDecoration dec(String h){ return InputDecoration(hintText: h,filled: true,fillColor: Color(0xFFF8F8FA),border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: Colors.grey.shade300))); }

  @override
  Widget build(BuildContext context){
    return DefaultTabController(length: 2,child: Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF4F46E5),foregroundColor: Colors.white,title: Text("Malik Pro"),actions: [
        IconButton(onPressed: (){
          showDialog(context: context, builder: (c)=> AlertDialog(title: Text("Logout?"),content: Text("Logout karna hai?"),actions: [TextButton(onPressed: ()=> Navigator.pop(c),child: Text("Cancel")), TextButton(onPressed: (){ Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c)=> LanguageScreen()), (r)=> false); },child: Text("Logout",style: TextStyle(color: Colors.red)))]));
        },icon: Icon(Icons.logout))
      ],bottom: TabBar(tabs: [Tab(text: "Nayi Job"),Tab(text: "My Jobs (${jobs.length})")]),),
      body: TabBarView(children: [
        SingleChildScrollView(padding: EdgeInsets.all(16),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Text("JOB TITLE*",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold)),SizedBox(height:6),TextField(controller: titleC,decoration: dec("e.g. Silai worker chahiye")),
          SizedBox(height:12),Text("CATEGORY",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold)),SizedBox(height:6),TextField(controller: catC,decoration: dec("e.g. Silai, Cutting, Packing")),
          SizedBox(height:12),Text("KITNE WORKER*",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold)),SizedBox(height:6),
          Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300),borderRadius: BorderRadius.circular(12)),child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
            IconButton(onPressed: (){ if(worker>1)setState(()=> worker--); },icon: Icon(Icons.remove_circle,color: Color(0xFF4F46E5))),
            Text("$worker",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
            IconButton(onPressed: (){ setState(()=> worker++); },icon: Icon(Icons.add_circle,color: Color(0xFF4F46E5))),
          ])),
          SizedBox(height:12),Text("LOCATION*",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold)),SizedBox(height:6),TextField(controller: locC,decoration: dec("Full Address")),
          SizedBox(height:12),Text("SALARY*",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold)),SizedBox(height:6),TextField(controller: salC,keyboardType: TextInputType.number,decoration: dec("e.g. 15000")),
          SizedBox(height:20),
          SizedBox(width: double.infinity,height: 52,child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4F46E5),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),onPressed: addJob,child: Text("Job Post Karo",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)))),
        ])),
        jobs.isEmpty? Center(child: Text("Abhi koi job nahi")) : ListView.builder(padding: EdgeInsets.all(12),itemCount: jobs.length,itemBuilder: (c,i){
          var j = jobs[i];
          return InkWell(onTap: (){ setState(()=> j["views"] = j["views"]+1); },child: Container(margin: EdgeInsets.only(bottom: 12),padding: EdgeInsets.all(14),decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(14),boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 5)]),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
            Text(j["title"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
            SizedBox(height: 4), Text("${j["cat"]} • ${j["worker"]} Workers • ${j["loc"]}",style: TextStyle(fontSize: 12,color: Colors.grey[600])),
            SizedBox(height: 4), Text("₹ ${j["sal"]} / month",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF4F46E5))),
            SizedBox(height: 10), Divider(height: 1), SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Row(children: [Icon(Icons.visibility,size: 14,color: Colors.grey),SizedBox(width: 4),Text("${j["views"]} views",style: TextStyle(fontSize: 11))]),
              InkWell(onTap: (){ setState(()=> jobs.removeAt(i)); },child: Row(children: [Icon(Icons.delete,size: 14,color: Colors.red),Text(" Delete",style: TextStyle(fontSize: 11,color: Colors.red))])),
              InkWell(onTap: ()=> shareWhatsApp(j),child: Row(children: [Icon(Icons.share,size: 14,color: Colors.green),Text(" WhatsApp",style: TextStyle(fontSize: 11,color: Colors.green,fontWeight: FontWeight.bold))])),
            ]),
          ])));
        }),
      ]),
    ));
  }
}
