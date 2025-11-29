import 'package:ship_tracker/core/common/dropdown_entity.dart';
import 'package:ship_tracker/features/supplier/data/models/supplier_detail_model.dart';
import 'package:ship_tracker/features/supplier/data/models/supplier_model.dart';
import 'package:ship_tracker/features/supplier/domain/entities/supplier_entity.dart';
import 'package:ship_tracker/features/supplier/domain/entities/supplier_detail_entity.dart';
import 'package:ship_tracker/features/supplier/domain/usecases/fetch_supplier_use_case.dart';
import 'package:ship_tracker/features/supplier/domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import 'package:ship_tracker/features/supplier/domain/usecases/fetch_suppliers_use_case.dart';
import 'package:ship_tracker/features/supplier/domain/usecases/create_supplier_use_case.dart';
import 'package:ship_tracker/features/supplier/domain/usecases/update_supplier_use_case.dart';

const tSupplierEntity = SupplierEntity(
  id: '71213ab2-eb64-4873-9732-a77681c9523f',
  name: 'ayyubi',
  phoneNumber: '087885020053',
  avatarUrl:
      'https://storage.dianmandirigrup.id/staging-app/supplier/avatar/f23d2884-66ac-4fe7-b1db-7f260014befa.jpg',
);
const tSupplierModel = SupplierModel(
  id: '71213ab2-eb64-4873-9732-a77681c9523f',
  name: 'ayyubi',
  phoneNumber: '087885020053',
  avatarUrl:
      'https://storage.dianmandirigrup.id/staging-app/supplier/avatar/f23d2884-66ac-4fe7-b1db-7f260014befa.jpg',
);

const tSupplierDetailEntity = SupplierDetailEntity(
  id: '71213ab2-eb64-4873-9732-a77681c9523f',
  name: 'ayyubi',
  phoneNumber: '087885020053',
  avatarUrl:
      'https://storage.dianmandirigrup.id/staging-app/supplier/avatar/f23d2884-66ac-4fe7-b1db-7f260014befa.jpg',
  address: 'pergudangan gracia tunggak jati jl. proklamasi',
  email: 'tk.ajib@gmail.com',
);
const tSupplierDetailModel = SupplierDetailModel(
  id: '71213ab2-eb64-4873-9732-a77681c9523f',
  name: 'ayyubi',
  phoneNumber: '087885020053',
  avatarUrl:
      'https://storage.dianmandirigrup.id/staging-app/supplier/avatar/f23d2884-66ac-4fe7-b1db-7f260014befa.jpg',
  address: 'pergudangan gracia tunggak jati jl. proklamasi',
  email: 'tk.ajib@gmail.com',
);

const tFetchSupplierParams = FetchSupplierUseCaseParams(
  supplierId: 'supplierId',
);
const tFetchSupplierSuccess = SupplierDetailEntity(
  id: '71213ab2-eb64-4873-9732-a77681c9523f',
  name: 'ayyubi',
  phoneNumber: '087885020053',
  avatarUrl:
      'https://storage.dianmandirigrup.id/staging-app/supplier/avatar/f23d2884-66ac-4fe7-b1db-7f260014befa.jpg',
  address: 'pergudangan gracia tunggak jati jl. proklamasi',
  email: 'tk.ajib@gmail.com',
);

const tFetchSuppliersParams = FetchSuppliersUseCaseParams();
const tFetchSuppliersSuccess = [
  SupplierEntity(
    id: '71213ab2-eb64-4873-9732-a77681c9523f',
    name: 'ayyubi',
    phoneNumber: '087885020053',
    avatarUrl:
        'https://storage.dianmandirigrup.id/staging-app/supplier/avatar/f23d2884-66ac-4fe7-b1db-7f260014befa.jpg',
  ),
];

const tFetchSuppliersDropdownParams = FetchSuppliersDropdownUseCaseParams();
const tFetchSuppliersDropdownSuccess = [
  DropdownEntity(key: '71213ab2-eb64-4873-9732-a77681c9523f', value: 'ayyubi'),
];

const tCreateSupplierParams = CreateSupplierUseCaseParams(
  name: 'name',
  phoneNumber: 'phoneNumber',
);
const tCreateSupplierSuccess = 'Supplier created successfully';

const tUpdateSupplierParams = UpdateSupplierUseCaseParams(
  supplierDetailEntity: SupplierDetailEntity(
    id: 'id',
    name: 'name',
    phoneNumber: 'phoneNumber',
  ),
);
const tUpdateSupplierSuccess = 'Success update supplier';
