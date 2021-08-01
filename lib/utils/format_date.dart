
String formatDateToString(String date){
  var time = DateTime.parse(date);
  return time.toLocal().toString().replaceAll(".000", "");
}


formatDateH(String date){
  var nowTime = new DateTime.now().toString().split('.')[0].replaceAll('-', '/');
  var oldTime = date.toString().split('.')[0].replaceAll('-', '/');

  int nowyear = int.parse(nowTime.split(" ")[0].split('/')[0]);
  int nowmonth = int.parse(nowTime.split(" ")[0].split('/')[1]);
  int nowday = int.parse(nowTime.split(" ")[0].split('/')[2]);
  int nowhour = int.parse(nowTime.split(" ")[1].split(':')[0]);
  int nowmin = int.parse(nowTime.split(" ")[1].split(':')[1]);

  int oldyear = int.parse(oldTime.split(" ")[0].split('/')[0]);
  int oldmonth = int.parse(oldTime.split(" ")[0].split('/')[1]);
  int oldday = int.parse(oldTime.split(" ")[0].split('/')[2]);
  int oldhour = int.parse(oldTime.split(" ")[1].split(':')[0]);
  int oldmin = int.parse(oldTime.split(" ")[1].split(':')[1]);

  var now = new DateTime(nowyear, nowmonth, nowday, nowhour, nowmin);
  var old = new DateTime(oldyear, oldmonth, oldday, oldhour, oldmin);
  var difference = now.difference(old);
  var h = difference.inHours;
  return h;
}
