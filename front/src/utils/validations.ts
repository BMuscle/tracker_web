import VueI18n from '@/locales/i18n'
import { LocaleMessage } from 'vue-i18n'
type RuleResult = LocaleMessage | boolean
export function required (value: string): RuleResult {
  return !!value || VueI18n.t('validation.required')
}
export function rangeString (
  value: string,
  minLength: number,
  maxLength: number
): RuleResult {
  return (
    (value.length >= minLength && value.length <= maxLength) ||
    VueI18n.t('validation.range_string', {
      minLength: minLength,
      maxLength: maxLength
    })
  )
}
