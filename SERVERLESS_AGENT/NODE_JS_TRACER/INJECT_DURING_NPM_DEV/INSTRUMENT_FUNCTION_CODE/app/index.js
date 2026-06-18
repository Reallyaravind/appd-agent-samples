// 1. Require and immediately initialize the AppDynamics Lambda tracer
const tracer = require('appdynamics-lambda-tracer');
tracer.init();

// 2. Your standard Lambda handler code
exports.handler = async (event, context) => {
    console.log("Hello World execution started");
    
    const response = {
        statusCode: 200,
        body: JSON.stringify({
            message: "Hello World! Monitoring is active via manual code instrumentation.",
        }),
    };

    return response;
};

// 3. Complete the instrumentation at the absolute end of the file
tracer.mainModule(module);