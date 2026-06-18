// Remove the tracer require and tracer.main wrapper
exports.handler = async (event, context) => {
    console.log("Hello World execution started");
    
    const response = {
        statusCode: 200,
        body: JSON.stringify({
            message: "Hello World! Monitoring is active via Layer.",
        }),
    };

    return response;
};