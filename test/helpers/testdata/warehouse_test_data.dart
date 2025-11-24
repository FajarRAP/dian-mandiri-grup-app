import 'package:ship_tracker/features/supplier/data/models/supplier_model.dart';
import 'package:ship_tracker/features/supplier/domain/entities/supplier_entity.dart';
import 'package:ship_tracker/features/warehouse/data/models/purchase_note_detail_model.dart';
import 'package:ship_tracker/features/warehouse/data/models/purchase_note_summary_model.dart';
import 'package:ship_tracker/features/warehouse/data/models/warehouse_item_model.dart';
import 'package:ship_tracker/features/warehouse/domain/entities/purchase_note_summary_entity.dart';
import 'package:ship_tracker/features/warehouse/domain/entities/warehouse_item_entity.dart';
import 'package:ship_tracker/features/warehouse/domain/entities/purchase_note_detail_entity.dart';

const tWarehouseItemEntity = WarehouseItemEntity(
  id: 'c5f50fa8-ec55-4f22-b2d9-b223da930ebd',
  name: 'lorem',
  quantity: 2,
  rejectQuantity: 0,
  price: 20000,
  shipmentFee: 20000,
);
const tWarehouseItemModel = WarehouseItemModel(
  id: 'c5f50fa8-ec55-4f22-b2d9-b223da930ebd',
  name: 'lorem',
  quantity: 2,
  rejectQuantity: 0,
  price: 20000,
  shipmentFee: 20000,
);

final tPurchaseNoteSummaryEntity = PurchaseNoteSummaryEntity(
  id: '83881607-18c5-4135-acb5-86f45892bd3c',
  supplier: const SupplierEntity(
      id: '71213ab2-eb64-4873-9732-a77681c9523f',
      name: 'Ayubi',
      phoneNumber: '087885020053',
      avatarUrl:
          'https://storage.dianmandirigrup.id/staging-app/supplier/avatar/f23d2884-66ac-4fe7-b1db-7f260014befa.jpg'),
  totalItems: 1,
  date: DateTime.parse('2025-09-27T17:00:00Z'),
);
final tPurchaseNoteSummaryModel = PurchaseNoteSummaryModel(
  id: '83881607-18c5-4135-acb5-86f45892bd3c',
  supplier: const SupplierModel(
      id: '71213ab2-eb64-4873-9732-a77681c9523f',
      name: 'Ayubi',
      phoneNumber: '087885020053',
      avatarUrl:
          'https://storage.dianmandirigrup.id/staging-app/supplier/avatar/f23d2884-66ac-4fe7-b1db-7f260014befa.jpg'),
  totalItems: 1,
  date: DateTime.parse('2025-09-27T17:00:00Z'),
);

final tPurchaseNoteDetailEntity = PurchaseNoteDetailEntity(
  id: '83881607-18c5-4135-acb5-86f45892bd3c',
  date: DateTime.parse('2025-09-27T17:00:00Z'),
  receipt:
      'https://storage.dianmandirigrup.id/staging-app/receipt_note/4a7c9809-0431-44b3-b61e-e47e83d3ee47.jpg',
  note: '',
  isEditable: true,
  returnCost: 0,
  supplier: const SupplierEntity(
    id: '71213ab2-eb64-4873-9732-a77681c9523f',
    name: 'Ayubi',
    phoneNumber: '087885020053',
    avatarUrl:
        'https://storage.dianmandirigrup.id/staging-app/supplier/avatar/f23d2884-66ac-4fe7-b1db-7f260014befa.jpg',
  ),
  totalPrice: 60000,
  items: [
    const WarehouseItemEntity(
      id: 'c5f50fa8-ec55-4f22-b2d9-b223da930ebd',
      name: 'lorem',
      quantity: 2,
      rejectQuantity: 0,
      price: 20000,
      shipmentFee: 20000,
    )
  ],
);
final tPurchaseNoteDetailModel = PurchaseNoteDetailModel(
  id: '83881607-18c5-4135-acb5-86f45892bd3c',
  date: DateTime.parse('2025-09-27T17:00:00Z'),
  receipt:
      'https://storage.dianmandirigrup.id/staging-app/receipt_note/4a7c9809-0431-44b3-b61e-e47e83d3ee47.jpg',
  note: '',
  isEditable: true,
  returnCost: 0,
  supplier: const SupplierModel(
    id: '71213ab2-eb64-4873-9732-a77681c9523f',
    name: 'Ayubi',
    phoneNumber: '087885020053',
    avatarUrl:
        'https://storage.dianmandirigrup.id/staging-app/supplier/avatar/f23d2884-66ac-4fe7-b1db-7f260014befa.jpg',
  ),
  totalPrice: 60000,
  items: [
    const WarehouseItemModel(
      id: 'c5f50fa8-ec55-4f22-b2d9-b223da930ebd',
      name: 'lorem',
      quantity: 2,
      rejectQuantity: 0,
      price: 20000,
      shipmentFee: 20000,
    )
  ],
);
