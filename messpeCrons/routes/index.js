const express = require('express');
const { collection, getDocs, getFirestore } = require('firebase/firestore');
const moment = require('moment');
const connectDB = require('../config/firebase');
const User = require('../config/firebase');
const router = express.Router();



// @route   GET /
// @desc    Get Data

router.get("/", async (req, res) => {


    const db = getFirestore(connectDB)
    const users = collection(db, 'users');
    const snapshot = await getDocs(users);
    const ids = snapshot.docs.map(doc => doc.id);
    // console.log(ids)
    const credit24hr = []
    const getTransactionOfCredit = async (ids) => {
        

        const val = ids.map(async id => {

            const creditForId = []
            const wallet = collection(db, `users/${id}/wallet`);
            const snapshot = await getDocs(wallet);
            const transactionList = snapshot.docs.map(doc => doc.data());
            var now = new Date().getTime();
            
            transactionList.map(transaction => {
                let now = moment(moment().toLocaleString())
                let hours = now.diff(moment(transaction.date), 'hours')
                // let hours = moment().local().diff(moment(new Date(transaction.date).toLocaleString()), 'hours');
                if (transaction.isAdded &&  !transaction.isReturn && !transaction.isConvertedToCredit && (hours >= 24) ) {
                    if(transaction['txStatus'] != null){
                        if(transaction['txStatus'] != 'FAILED'){
                            console.log("Convert into credit - " + transaction.id)
                            creditForId.push(transaction)
                        }
                    }
                    else{
                        console.log("Convert into credit - " + transaction.id)
                        creditForId.push(transaction)
                    }
                    
                }
                
            })

            return { id, creditForId }
        })
        const res = await Promise.all(val);
        return res;
        
    }

    getTransactionOfCredit(ids).then(list => {
        res.json(list.filter(item=>item.creditForId.length>0))
    })

    // console.log(credit24hr)
    
    // const userList = snapshot.docs.map(doc => doc.data());
    // res.json(userList)
})

router.get("/point-to-credit", async(req, res)=>{
    const db = getFirestore(connectDB)
    const users = collection(db, 'users');
    const snapshot = await getDocs(users);
    const ids = snapshot.docs.map(doc => doc.id);
    const getTransactionOfCredit = async (ids) => {
        

        const val = ids.map(async id => {

            const creditForId = []
            const wallet = collection(db, `users/${id}/wallet`);
            const snapshot = await getDocs(wallet);
            const transactionList = snapshot.docs.map(doc => doc.data());
            var now = new Date().getTime();
            
            transactionList.map(transaction => {
                let now = moment(moment().toLocaleString())
                let days = now.diff(moment(transaction.date), 'days')
                console.log(days)
                // let hours = moment().local().diff(moment(new Date(transaction.date).toLocaleString()), 'hours');
                if (transaction.isReferred && !transaction.isReturn && !transaction.isConvertedToCredit && !transaction.isAdded && (days >= 30)) {
                    if(transaction['txStatus'] != null){
                        if(transaction['txStatus'] != 'FAILED'){
                            console.log("Convert into credit - " + transaction.id)
                            creditForId.push(transaction)
                        }
                    }
                    else{
                        console.log("Convert into credit - " + transaction.id)
                        creditForId.push(transaction)
                    }
                    
                }
                
            })

            return { id, creditForId }
        })
        const res = await Promise.all(val);
        return res;
        
    }

    getTransactionOfCredit(ids).then(list => {
        res.json(list.filter(item=>item.creditForId.length>0))
    })
})

module.exports = router;