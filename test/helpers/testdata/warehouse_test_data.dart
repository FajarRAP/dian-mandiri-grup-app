import 'package:ship_tracker/features/supplier/data/models/supplier_model.dart';
import 'package:ship_tracker/features/supplier/domain/entities/supplier_entity.dart';
import 'package:ship_tracker/features/warehouse/data/models/purchase_note_detail_model.dart';
import 'package:ship_tracker/features/warehouse/data/models/purchase_note_summary_model.dart';
import 'package:ship_tracker/features/warehouse/data/models/warehouse_item_model.dart';
import 'package:ship_tracker/features/warehouse/domain/entities/purchase_note_summary_entity.dart';
import 'package:ship_tracker/features/warehouse/domain/entities/warehouse_item_entity.dart';
import 'package:ship_tracker/features/warehouse/domain/entities/purchase_note_detail_entity.dart';
import 'package:ship_tracker/features/warehouse/domain/usecases/delete_purchase_note_use_case.dart';
import 'package:ship_tracker/features/warehouse/domain/usecases/fetch_purchase_note_use_case.dart';
import 'package:ship_tracker/features/warehouse/domain/usecases/fetch_purchase_notes_use_case.dart';
import 'package:ship_tracker/features/warehouse/domain/usecases/fetch_purchase_notes_dropdown_use_case.dart';
import 'package:ship_tracker/features/warehouse/domain/usecases/create_purchase_note_use_case.dart';
import 'package:ship_tracker/features/warehouse/domain/usecases/import_purchase_note_use_case.dart';
import 'package:ship_tracker/features/warehouse/domain/usecases/update_return_cost_use_case.dart';
import 'package:ship_tracker/features/warehouse/domain/usecases/add_shipping_fee_use_case.dart';
import 'package:ship_tracker/features/warehouse/domain/usecases/update_purchase_note_use_case.dart';
import 'package:ship_tracker/core/domain/entities/dropdown_entity.dart';

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
        'https://storage.dianmandirigrup.id/staging-app/supplier/avatar/f23d2884-66ac-4fe7-b1db-7f260014befa.jpg',
  ),
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
        'https://storage.dianmandirigrup.id/staging-app/supplier/avatar/f23d2884-66ac-4fe7-b1db-7f260014befa.jpg',
  ),
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
    ),
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
    ),
  ],
);

const tDeletePurchaseNoteParams = DeletePurchaseNoteUseCaseParams(
  purchaseNoteId: 'purchaseNoteId',
);
const tDeletePurchaseNoteSuccess = 'Success delete purchase note!';

final tFetchPurchaseNoteParams = FetchPurchaseNoteUseCaseParams(
  purchaseNoteId: tPurchaseNoteDetailEntity.id,
);
final tFetchPurchaseNoteSuccess = PurchaseNoteDetailEntity(
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
    ),
  ],
);

const tFetchPurchaseNotesParams = FetchPurchaseNotesUseCaseParams();
final tFetchPurchaseNotesSuccess = [
  PurchaseNoteSummaryEntity(
    id: '83881607-18c5-4135-acb5-86f45892bd3c',
    supplier: const SupplierEntity(
      id: '71213ab2-eb64-4873-9732-a77681c9523f',
      name: 'Ayubi',
      phoneNumber: '087885020053',
      avatarUrl:
          'https://storage.dianmandirigrup.id/staging-app/supplier/avatar/f23d2884-66ac-4fe7-b1db-7f260014befa.jpg',
    ),
    totalItems: 1,
    date: DateTime.parse('2025-09-27T17:00:00Z'),
  ),
];

const tFetchPurchaseNotesDropdownParams =
    FetchPurchaseNotesDropdownUseCaseParams();
const tFetchPurchaseNotesDropdownSuccess = [
  DropdownEntity(
    key: '83881607-18c5-4135-acb5-86f45892bd3c',
    value: '2025-09-27 - Ayubi',
  ),
];

final tInsertPurchaseNoteManualParams = CreatePurchaseNoteUseCaseParams(
  date: DateTime.now(),
  receipt: 'receipt',
  supplierId: 'supplierId',
  items: const [
    WarehouseItemEntity(
      id: 'c5f50fa8-ec55-4f22-b2d9-b223da930ebd',
      name: 'lorem',
      quantity: 2,
      rejectQuantity: 0,
      price: 20000,
      shipmentFee: 20000,
    ),
  ],
);
const tInsertPurchaseNoteManualSuccess = 'Purchase note created successfully';

final tInsertPurchaseNoteFileParams = ImportPurchaseNoteUseCaseParams(
  date: DateTime.now(),
  receipt: 'receipt',
  supplierId: 'supplierId',
  file: 'file',
);
const tInsertPurchaseNoteFileSuccess = 'Purchase note created successfully';

const tUpdateReturnCostParams = UpdateReturnCostUseCaseParams(
  purchaseNoteId: 'purchaseNoteId',
  amount: 10000,
);
const tUpdateReturnCostSuccess =
    'Purchase note return cost updated successfully';

const tInsertShippingFeeParams = AddShippingFeeUseCaseParams(
  price: 5000,
  purchaseNoteIds: ['purchaseNoteId'],
);
const tInsertShippingFeeSuccess = 'Success create shipment price!';

final tUpdatePurchaseNoteParams = UpdatePurchaseNoteUseCaseParams(
  purchaseNoteId: 'purchaseNoteId',
  date: DateTime.now(),
  receipt: 'https://receipt',
  supplierId: 'supplierId',
  items: const [
    WarehouseItemEntity(
      id: 'c5f50fa8-ec55-4f22-b2d9-b223da930ebd',
      name: 'lorem',
      quantity: 2,
      rejectQuantity: 0,
      price: 20000,
      shipmentFee: 20000,
    ),
  ],
);
const tUpdatePurchaseNoteSuccess = 'Purchase note updated successfully';
