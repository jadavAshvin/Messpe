const { getFirestore, getDocs, collection } = require("firebase/firestore");
const connectDB = require("../config/firebase");

const dbConnect = ()=>{
    
    return getFirestore(connectDB)
    
}

module.exports = dbConnect