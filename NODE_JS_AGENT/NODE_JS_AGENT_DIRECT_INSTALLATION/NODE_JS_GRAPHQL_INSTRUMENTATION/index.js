const appd = require('appdynamics');

appd.profile({
  controllerHostName: '<controller host name>',
  controllerPort: <controller_port_number>,
  controllerSslEnabled: false,  // Set to true if controllerPort is SSL
  accountName: '<AppDynamics_account_name>',
  accountAccessKey: '<AppDynamics_account_key>', //required
  applicationName: 'your_app_name',
  noNodeNameSuffix: true,
  tierName: 'choose_a_tier_name',
    nodeName: 'choose_a_node_name',
  logging: {
    'logfiles': [{
      'root_directory': '/tmp/appd',
      'level': 'TRACE'
    }]
  },
  enableGraphQL: true, // Crucial for Apollo/GraphQL visibility
});


const { ApolloServer } = require('@apollo/server');
const { ApolloServerPluginDrainHttpServer } = require('@apollo/server/plugin/drainHttpServer');
const { expressMiddleware } = require('@apollo/server/express4');
const express = require('express'); // Added missing express requirement
const http = require('http'); // Changed from import to require for consistency
const cors = require('cors');

const typeDefs = `#graphql
  type Book {
    title: String
    author: String
  }  
  type Query {
    books: [Book]
  }
`;

const books = [
  { title: 'The Awakening', author: 'Kate Chopin' },
  { title: 'City of Glass', author: 'Paul Auster' },
];

const resolvers = {
  Query: {
    books: () => books,
  },
};

async function startServer() {
  const app = express();
  const httpServer = http.createServer(app);

  const server = new ApolloServer({
    typeDefs,
    resolvers,
    plugins: [ApolloServerPluginDrainHttpServer({ httpServer })],
  });

  await server.start();

  app.use(
    '/graphql',
    cors(),
    express.json(),
    expressMiddleware(server, {
      context: async ({ req }) => ({ token: req.headers.token }),
    }),
  );

  await new Promise((resolve) =>
    httpServer.listen({ port: 4000 }, resolve),
  );
  
  console.log(`🚀 Server ready at http://localhost:4000/graphql`);
}

startServer().catch(err => {
  console.error('Error starting server:', err);
});