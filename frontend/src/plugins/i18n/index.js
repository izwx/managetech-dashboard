import enMessages from '@/plugins/i18n/locales/en'
import jaMessages from '@/plugins/i18n/locales/ja'
import Vue from 'vue'
import VueI18n from 'vue-i18n'
import dateTimeFormats from './date-time-format'

Vue.use(VueI18n)

export const i18n = new VueI18n({
  legacy: false,
  allowComposition: true,
  locale: 'ja', // set locale
  fallbackLocale: 'ja',
  dateTimeFormats,
  messages: {
    en: enMessages,
    ja: jaMessages,
  }, // set locale messages
})

const loadedLanguages = ['ja', 'en'] // our default language that is preloaded

function setI18nLanguage(lang) {
  i18n.locale = lang

  return lang
}

export function loadLanguageAsync(lang) {
  // If the same language
  if (i18n.locale === lang) {
    return Promise.resolve(setI18nLanguage(lang))
  }

  // If the language was already loaded
  if (loadedLanguages.includes(lang)) {
    return Promise.resolve(setI18nLanguage(lang))
  }

  // If the language hasn't been loaded yet
  /* eslint-disable prefer-template */
  return import(/* webpackChunkName: "lang-[request]" */ '@/plugins/i18n/locales/' + lang + '.js').then(msgs => {
    i18n.setLocaleMessage(lang, msgs.default)
    loadedLanguages.push(lang)

    return setI18nLanguage(lang)
  })
  /* eslint-enable */
}
