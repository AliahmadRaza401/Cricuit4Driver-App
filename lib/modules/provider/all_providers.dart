
import 'package:circuit4driver/modules/provider/home_providers.dart';
import 'package:provider/provider.dart';

var allProvider = [

    ChangeNotifierProvider<HomeProvider>(
    create: (_) => HomeProvider(),
    lazy: true,
  ),
 
 



 
];

