import 'package:cloud_firestore/cloud_firestore.dart';

class SequentialIdService {
  SequentialIdService([FirebaseFirestore? firestore]) : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  //Returns the next id  eg: nextId('replies', 'reply_1'
  Future<String> nextId(String collection, String prefix) async{
    final counterRef = _firestore.collection('counters').doc(collection);
    try{
      //Use a transaction to automatically increment teh counter
      //if the counter document doesn't exist yet, it automatically starts at 1,
      return await _firestore.runTransaction<String>((tx) async{
        final snap = await tx.get(counterRef);
        int current = 0;
        if(snap.exists && snap.data()?['value'] is num){
          current = (snap.data()!['value'] as num).toInt();
        }
        final next = current + 1;
        tx.set(
          counterRef,
          {'value': next, 'prefix': prefix},
          SetOptions(merge:true),
        );
        return '$prefix$next';
      });
    }catch(_){
      return '$prefix${DateTime.now().millisecondsSinceEpoch}';
    }

  }

}