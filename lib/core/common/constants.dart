const loginRoute = "/login";
const getTokenResetPasswordRoute = "/get-token-reset-password";
const resetPasswordRoute = "/reset-password";

const trackerRoute = "/";
const scanReceiptRoute = "${trackerRoute}scan";
const pickUpReceiptRoute = "${trackerRoute}pick-up";
const checkReceiptRoute = "${trackerRoute}check";
const packReceiptRoute = "${trackerRoute}pack";
const sendReceiptRoute = "${trackerRoute}send";
const returnReceiptRoute = "${trackerRoute}return";
const reportRoute = "${trackerRoute}report";
const receiptStatusRoute = "${trackerRoute}status";
const detailReceiptRoute = "${trackerRoute}detail";
const cameraRoute = "${trackerRoute}camera";

const profileRoute = "/profile";
const registerRoute = "$profileRoute/register";

const barcodeScannerRoute = "/barcode-scanner";
const displayPictureRoute = "/picture";

const scanStage = 'scan';
const pickUpStage = 'pick_up';
const checkStage = 'check';
const packStage = 'pack';
const sendStage = 'send';
const returnStage = 'return';

const spreadsheetIcon = "assets/excel.png";
const scanReceiptIcon = "assets/scan.png";
const pickUpReceiptIcon = "assets/pick-up.png";
const checkReceiptIcon = "assets/check.png";
const packReceiptIcon = "assets/pack.png";
const sendReceiptIcon = "assets/send.png";
const returnReceiptIcon = "assets/return.png";
const reportReceiptIcon = "assets/report.png";
const checkReceiptStatusIcon = "assets/check-receipt.png";
const googleIcon = "assets/google-icon.png";

const successSound = "sounds/success.mp3";
const skipSound = "sounds/skip.mp3";
const repeatSound = "sounds/repeat.mp3";

const scanRole = 2;
const pickUpRole = 3;
const checkRole = 4;
const packRole = 5;
const sendRole = 6;
const returnRole = 7;
const pickUpAndPackRole = 8;
const packAndSendRole = 9;

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

enum ScanType { camera, scannner }

const apiUrl = String.fromEnvironment('API_URL');
const shipmentEndpoint = String.fromEnvironment('SHIPMENT_ENDPOINT');
const authEndpoint = String.fromEnvironment('AUTH_ENDPOINT');
const accessTokenKey = String.fromEnvironment('ACCESS_TOKEN_KEY');
const refreshTokenKey = String.fromEnvironment('REFRESH_TOKEN_KEY');
const userKey = String.fromEnvironment('USER_KEY');
