// https://docs.cypress.io/api/introduction/api.html

describe('Home Page', () => {
  beforeEach(() => {
    cy.exec('bundle exec rails db:reset RAILS_ENV=test')
    cy.task('dbUserCreate', [
      {
        model: 'User',
        params: {
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    ])
  })

  describe('ログインした時', () => {
    beforeEach(() => {
      cy.visit('/log_in')
      cy.get('input[name=email]').type('test@example.com')
      cy.get('input[name=password]').type('password')
      cy.get('#log_in').click()
    })

    it('Homeページに遷移し、Emailが表示されること', () => {
      cy.contains('test@example.com')
    })
  })

  describe('ログインしていない時', () => {
    beforeEach(() => {
      cy.visit('/')
    })
    it('', () => {
      cy.contains('My name is rails')
      cy.get('.email').should('be.empty')
    })
  })
})
