// https://docs.cypress.io/api/introduction/api.html

describe('Dashboard Page', () => {
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

    it('ダッシュボード画面へ遷移していること', () => {
      cy.location().should((loc) => {
        expect(loc.pathname).to.eq('/dashboard')
      })
    })
  })

  describe('ログインしていない時', () => {
    beforeEach(() => {
      cy.visit('/dashboard')
    })
    it('ログイン画面へリダイレクトしていること', () => {
      cy.location().should((loc) => {
        expect(loc.pathname).to.eq('/log_in')
      })
    })
  })
})
