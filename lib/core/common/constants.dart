import 'package:flutter/material.dart';

const homeRoute = "/";

const loginRoute = "/login";
const displayPictureRoute = "/picture";

const supplierRoute = "${homeRoute}supplier";
const addSupplierRoute = "$supplierRoute/add";
const editSupplierRoute = "$supplierRoute/edit";
const supplierDetailRoute = "$supplierRoute/detail";

const warehouseRoute = "${homeRoute}warehouse";
const addShippingFeeRoute = "$warehouseRoute/add-shipping-fee";
const addPurchaseNoteManualRoute = "$warehouseRoute/add-purchase-note-manual";
const addPurchaseNoteFileRoute = "$warehouseRoute/add-purchase-note-file";
const purchaseNoteDetailRoute = "$warehouseRoute/detail";

const trackerRoute = "${homeRoute}tracker";
const scanReceiptRoute = "$trackerRoute/scan";
const pickUpReceiptRoute = "$trackerRoute/pick-up";
const checkReceiptRoute = "$trackerRoute/check";
const packReceiptRoute = "$trackerRoute/pack";
const sendReceiptRoute = "$trackerRoute/send";
const returnReceiptRoute = "$trackerRoute/return";
const cancelReceiptRoute = "$trackerRoute/cancel";
const reportRoute = "$trackerRoute/report";
const receiptStatusRoute = "$trackerRoute/status";
const detailReceiptRoute = "$trackerRoute/detail";
const cameraRoute = "$trackerRoute/camera";

const staffManagementRoute = "${homeRoute}staff-management";

const profileRoute = "${homeRoute}profile";

const iconsPath = "assets/icons";
const spreadsheetIcon = "$iconsPath/excel.png";
const scanReceiptIcon = "$iconsPath/scan.png";
const pickUpReceiptIcon = "$iconsPath/pick-up.png";
const checkReceiptIcon = "$iconsPath/check.png";
const packReceiptIcon = "$iconsPath/pack.png";
const sendReceiptIcon = "$iconsPath/send.png";
const returnReceiptIcon = "$iconsPath/return.png";
const cancelReceiptIcon = "$iconsPath/cancel.png";
const reportReceiptIcon = "$iconsPath/report.png";
const checkReceiptStatusIcon = "$iconsPath/check.png";
const googleIcon = "$iconsPath/google.png";

const soundsPath = "sounds";
const successSound = "$soundsPath/success.mp3";
const skipSound = "$soundsPath/skip.mp3";
const repeatSound = "$soundsPath/repeat.mp3";

const svgPath = 'assets/svgs';
const boxPenSvg = '$svgPath/box-pen.svg';
const boxSvg = '$svgPath/box.svg';
const cartSvg = '$svgPath/cart.svg';
const categorySquareSvg = '$svgPath/category-square.svg';
const categorySvg = '$svgPath/category.svg';
const dollarSvg = '$svgPath/dollar.svg';
const personMenuSvg = '$svgPath/person-menu.svg';
const personSquareSvg = '$svgPath/person-square.svg';
const personSvg = '$svgPath/person.svg';
const reportV1Svg = '$svgPath/report-v1.svg';
const reportV2Svg = '$svgPath/report-v2.svg';
const reportV3Svg = '$svgPath/report-v3.svg';
const reportV4Svg = '$svgPath/report-v4.svg';
const reportV5Svg = '$svgPath/report-v5.svg';
const warehouseSvg = '$svgPath/warehouse.svg';

const scanStage = 'scan';
const pickUpStage = 'pick_up';
const checkStage = 'check';
const packStage = 'pack';
const sendStage = 'send';
const returnStage = 'return';
const cancelStage = 'cancel';

const superAdminPermission = 'super_admin';
const scanPermission = 'shipment:$scanStage';
const pickUpPermission = 'shipment:$pickUpStage';
const checkPermission = 'shipment:$checkStage';
const packPermission = 'shipment:$packStage';
const sendPermission = 'shipment:$sendStage';
const returnPermission = 'shipment:$returnStage';

const pendingReport = 'pending';
const processingReport = 'processing';
const completedReport = 'completed';
const failedReport = 'failed';

const apiUrl = String.fromEnvironment('API_URL');
const shipmentEndpoint = String.fromEnvironment('SHIPMENT_ENDPOINT');
const authEndpoint = String.fromEnvironment('AUTH_ENDPOINT');
const accessTokenKey = String.fromEnvironment('ACCESS_TOKEN_KEY');
const refreshTokenKey = String.fromEnvironment('REFRESH_TOKEN_KEY');
const userKey = String.fromEnvironment('USER_KEY');

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
