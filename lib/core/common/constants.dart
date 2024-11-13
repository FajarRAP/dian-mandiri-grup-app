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

const scanStage = 2;
const pickUpStage = 3;
const checkStage = 4;
const packStage = 5;
const sendStage = 6;
const returnStage = 7;

const spreadsheetIcon = "assets/excel.png";
const scanReceiptIcon = "assets/scan.png";
const pickUpReceiptIcon = "assets/pick-up.png";
const checkReceiptIcon = "assets/check.png";
const packReceiptIcon = "assets/pack.png";
const sendReceiptIcon = "assets/send.png";
const returnReceiptIcon = "assets/return.png";
const reportReceiptIcon = "assets/report.png";
const checkReceiptStatusIcon = "assets/check-receipt.png";

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

enum ScanType { camera, scannner }
