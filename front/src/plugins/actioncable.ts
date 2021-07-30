import { createConsumer } from '@rails/actioncable'

export const cable = createConsumer(
  `${process.env.VUE_APP_BACK_END_ACTIONCABLE_API_URL}/cable`
)
