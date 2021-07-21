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
      cy.visit('/')
    })

    it('ナビゲーションバーがログイン状態用の表示になっていること', () => {
      cy.get('#public_navigation_bar').contains('button', 'ログアウト')
      cy.get('#public_navigation_bar').contains('button', 'ダッシュボード')
      cy.get('#public_navigation_bar').contains('button', 'ログイン').should('not.exist')
      cy.get('#public_navigation_bar').contains('button', 'サインアップ').should('not.exist')
    })
  })

  describe('ログインしていない時', () => {
    beforeEach(() => {
      cy.visit('/')
    })
    it('ナビゲーションばーがログアウト状態用の表示になっていること', () => {
      cy.get('#public_navigation_bar').contains('button', 'ログイン')
      cy.get('#public_navigation_bar').contains('button', 'サインアップ')
      cy.get('#public_navigation_bar').contains('button', 'ログアウト').should('not.exist')
      cy.get('#public_navigation_bar').contains('button', 'ダッシュボード').should('not.exist')
    })
  })
})
