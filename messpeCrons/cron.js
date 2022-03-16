const cron = require('node-cron')

const shell = require('shelljs')

const task = cron.schedule('*/1 * * * *', ()=>{
    console.log("Running cron for 24hr conversion")
    if(shell.exec('node crons/convertToCredit.js').code !== 0){
        console.log("Something wrong")
    }

    
    
},
{
    scheduled: true,
})

cron.schedule('*/2 * * * *', ()=>{
    console.log("Running cron for 30day conversion")
    if(shell.exec('node crons/convertToCredit30days.js').code !== 0){
        console.log("Something wrong")
    }
})

task.start()








