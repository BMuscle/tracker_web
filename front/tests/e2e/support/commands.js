// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
// -- This is will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })

Cypress.Commands.add('logIn', (email, password) => {
  cy.visit('/log_in')
  cy.get('input[name=email]').type(email)
  cy.get('input[name=password]').type(password)
  cy.get('#log_in').click()
})

Cypress.Commands.add('logOut', () => {
  cy.visit('/')
  cy.get('#log_out_button').click()
})

Cypress.Commands.add('dbReset', () => {
  cy.exec('bundle exec rails db:reset RAILS_ENV=test')
})

Cypress.Commands.add('createLogInUser', (email, password) => {
  cy.task('dbUserCreate', [
    {
      model: 'User',
      params: {
        email: email,
        password: password,
        password_confirmation: password
      }
    }
  ])
})

Cypress.Commands.add('dbUserAssociationCreate', (email, model, params) => {
  cy.task('dbUserAssociationCreate', [
    {
      model: model,
      params: params,
      options: {
        email: email
      }
    }
  ])
})
