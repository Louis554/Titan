import 'package:myecl/loan/class/item.dart';
import 'package:myecl/loan/class/loaner.dart';
import 'package:myecl/tools/functions.dart';
import 'package:myecl/user/class/list_users.dart';

class Loan {
  Loan({
    required this.id,
    required this.loaner,
    required this.borrower,
    required this.notes,
    required this.start,
    required this.end,
    required this.caution,
    required this.items,
  });
  late final String id;
  late final Loaner loaner;
  late final SimpleUser borrower;
  late final String notes;
  late final DateTime start;
  late final DateTime end;
  late final String caution;
  late final List<Item> items;

  Loan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    borrower = SimpleUser.fromJson(json['borrower']);
    loaner = Loaner.fromJson(json['loaner']);
    notes = json['notes'];
    start = DateTime.parse(json['start']);
    end = DateTime.parse(json['end']);
    caution = json['caution'];
    items = List<Item>.from(json['items'].map((x) => Item.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['borrower_id'] = borrower.id;
    _data['loaner_id'] = loaner.id;
    _data['notes'] = notes;
    _data['start'] = processDateToAPI(start);
    _data['end'] = processDateToAPI(end);
    _data['caution'] = caution;
    _data['item_ids'] = items.map((x) => x.id).toList();
    return _data;
  }

  Loan copyWith({id, loaner, borrower, notes, start, end, caution, items}) {
    return Loan(
        id: id ?? this.id,
        loaner: loaner ?? this.loaner,
        borrower: borrower ?? this.borrower,
        notes: notes ?? this.notes,
        start: start ?? this.start,
        end: end ?? this.end,
        caution: caution ?? this.caution,
        items: items ?? this.items);
  }
}
