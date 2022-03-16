const axios = require('axios');
const { getFirestore, collection, getDocs, setDoc, doc, getDoc } = require('firebase/firestore');
const connectDB = require('../config/firebase');
const dbConnect = require('./dbConnect');



const db = dbConnect();

axios({
    method: 'GET',
    url: 'http://localhost:3002',

}).then(async res => {
    console.log("Fetching users having points to be converted to credit")
    const newData = []
    if (res.data.length) {
        res.data.map(user => {
            let creditsConverted = 0
            user.creditForId.map(transaction => {
                creditsConverted += Number(transaction.points)
                transaction.isConvertedToCredit = true
            })
            newData.push({
                id: user.id,
                creditForId: user.creditForId,
                creditsConverted: creditsConverted
            })

        })
        // console.log("New Data" + newData.map(item=>item.creditForId))

        newData.map(async user => {
            try {
                const wallet = collection(db, `users/${user.id}/wallet`);
                const snapshot = await getDocs(wallet);

                const success = user.creditForId.map(async transaction => {
                    const ids = snapshot.docs.map(doc => doc.id);

                    const id = ids.find(id => id == transaction.id)
                    // console.log(id, transaction)
                    if (id) {
                        const current = doc(db, `users/${user.id}/wallet/${id}`)
                        try {
                            const list = (await getDoc(current)).data()
                            console.log(list)
                            await setDoc(current, transaction).then(async () => {
                                console.log("Converted to credit - " + transaction.id)
                                return true
                            })


                        }
                        catch (err) {
                            console.log(err)
                            console.log("Error in converting to credit - " + transaction.id)
                            return false
                        }
                        //   console.log(current)
                    }

                })

                if (success) {
                    const userSingle = doc(db, `users/${user.id}`)
                    const getCredits = Number((await getDoc(userSingle)).data().credits)
                    await setDoc(userSingle, {

                        credits: getCredits + user.creditsConverted
                    }, { merge: true }).then(() => {
                        console.log("Credits converted - " + user.creditsConverted)
                    })

                    process.exit(0)
                }
            }
            catch (err) {
                console.log(err)
                process.exit(0)
            }


        })
    }

    else {
        console.log("No users found")
        process.exit(0)
    }


    // newData.map(user=>{
    //     console.log(user)
    // })

})