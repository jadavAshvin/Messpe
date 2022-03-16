const { initializeApp } =  require('firebase/app');
const { getFirestore } = require('firebase/firestore/lite');


const firebaseConfig = {
  apiKey: "AIzaSyCy_4HzMkQAd7o1cOxOUQibqTZwslhGHQA",
  authDomain: "messpe-494e0.firebaseapp.com",
  projectId: "messpe-494e0",
  storageBucket: "messpe-494e0.appspot.com",
  messagingSenderId: "181953101872",
  appId: "1:181953101872:web:2c6f036a598da35cc2adf5"
  };

  let connectDB

  try{
    connectDB = initializeApp(firebaseConfig);
    
    if(connectDB){
      console.log("Database connected")
    }
  }
  catch(err){
    console.log(err)
  }
  

  module.exports = connectDB




