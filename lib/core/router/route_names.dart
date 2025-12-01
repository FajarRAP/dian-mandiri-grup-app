class Routes {
  const Routes._();

  static const login = 'login';
  static const home = 'home';

  // Tracker
  static const tracker = 'tracker';
  static const trackerScan = 'tracker.scan';
  static const trackerPickUp = 'tracker.pick_up';
  static const trackerCheck = 'tracker.check';
  static const trackerPack = 'tracker.pack';
  static const trackerSend = 'tracker.send';
  static const trackerReturn = 'tracker.return';
  static const trackerCancel = 'tracker.cancel';
  static const trackerReport = 'tracker.report';
  static const trackerStatus = 'tracker.status';
  static const trackerDetail = 'tracker.detail';
  static const trackerPickedDocument = '$trackerDetail.picked_document';

  // Supplier
  static const supplier = 'supplier';
  static const supplierDetail = 'supplier.detail';
  static const supplierAdd = 'supplier.add';
  static const supplierEdit = 'supplier.edit';

  // Warehouse
  static const warehouse = 'warehouse';
  static const warehouseDetail = 'warehouse.detail';
  static const warehouseCreatePurchaseNote = 'warehouse.create_purchase_note';
  static const warehouseAddPurchaseNoteFile =
      'warehouse.add_purchase_note_file';
  static const warehouseAddShippingFee = 'warehouse.add_shipping_fee';

  // Staff Management
  static const staffManagement = 'staff_management';

  // Profile
  static const profile = 'profile';
}
