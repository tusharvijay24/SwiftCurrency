//
//  CvCellCurrency.swift
//  SwiftCurrency
//
//  Created by Tushar on 15/08/24.
//

import UIKit
import FlagKit

class CvCellCurrency: UICollectionViewCell {
    
    @IBOutlet weak var imgCountryIcon: UIImageView!
    @IBOutlet weak var lblAmount: UILabel!
    
    func config(with currencyCode: String, amount: Double) {
        let currencySymbol = currencyCodeToSymbol(currencyCode)
        lblAmount.text = String(format: "\(currencySymbol) %.2f", amount)
        
        if let countryCode = currencyCodeToCountryCode(currencyCode), let flag = Flag(countryCode: countryCode) {
            imgCountryIcon.image = flag.image(style: .roundedRect)
        } else {
            imgCountryIcon.image = UIImage(named: "cross")
        }
        if imgCountryIcon.image == nil {
            imgCountryIcon.image = UIImage(named: "cross")
        }
        
        imgCountryIcon.contentMode = .scaleAspectFit
        imgCountryIcon.clipsToBounds = true
    }
    
    private func currencyCodeToCountryCode(_ currencyCode: String) -> String? {
        let mapping: [String: String] = [
            "USD": "US",  // United States Dollar
            "EUR": "EU",  // Euro
            "JPY": "JP",  // Japanese Yen
            "GBP": "GB",  // British Pound Sterling
            "CHF": "CH",  // Swiss Franc
            "CNY": "CN",  // Chinese Yuan
            "SEK": "SE",  // Swedish Krona
            "NZD": "NZ",  // New Zealand Dollar
            "MXN": "MX",  // Mexican Peso
            "SGD": "SG",  // Singapore Dollar
            "HKD": "HK",  // Hong Kong Dollar
            "NOK": "NO",  // Norwegian Krone
            "KRW": "KR",  // South Korean Won
            "TRY": "TR",  // Turkish Lira
            "RUB": "RU",  // Russian Ruble
            "INR": "IN",  // Indian Rupee
            "BRL": "BR",  // Brazilian Real
            "PLN": "PL",  // Polish Zloty
            "THB": "TH",  // Thai Baht
            "MYR": "MY",  // Malaysian Ringgit
            "IDR": "ID",  // Indonesian Rupiah
            "AED": "AE",  // United Arab Emirates Dirham
            "SAR": "SA",  // Saudi Riyal
            "COP": "CO",  // Colombian Peso
            "NGN": "NG",  // Nigerian Naira
            "PKR": "PK",  // Pakistani Rupee
            "QAR": "QA",  // Qatari Rial
            "BDT": "BD",  // Bangladeshi Taka
            "BHD": "BH",  // Bahraini Dinar
            "SZL": "SZ",  // Swazi Lilangeni
            "CRC": "CR",  // Costa Rican Colón
            "MMK": "MM",  // Myanmar Kyat
            "RON": "RO",  // Romanian Leu
            "SOS": "SO",  // Somali Shilling
            "CDF": "CD",  // Congolese Franc
            "ERN": "ER",  // Eritrean Nakfa
            "MOP": "MO",  // Macanese Pataca
            "GIP": "GI",  // Gibraltar Pound
            "XAU": "XA",  // Gold Ounce
            "BND": "BN",  // Brunei Dollar
            "TZS": "TZ",  // Tanzanian Shilling
            "GGP": "GG",  // Guernsey Pound
            "XCD": "XC",  // East Caribbean Dollar
            "PYG": "PY",  // Paraguayan Guarani
            "ANG": "AN",  // Netherlands Antillean Guilder
            "SRD": "SR",  // Surinamese Dollar
            "BYN": "BY",  // Belarusian Ruble
            "SHP": "SH",  // Saint Helena Pound
            "HNL": "HN",  // Honduran Lempira
            "OMR": "OM",  // Omani Rial
            "LYD": "LY",  // Libyan Dinar
            "GNF": "GN",  // Guinean Franc
            "PEN": "PE",  // Peruvian Sol
            "MAD": "MA",  // Moroccan Dirham
            "FJD": "FJ",  // Fijian Dollar
            "BZD": "BZ",  // Belize Dollar
            "UYU": "UY",  // Uruguayan Peso
            "KES": "KE",  // Kenyan Shilling
            "AMD": "AM",  // Armenian Dram
            "TOP": "TO",  // Tongan Paʻanga
            "BOB": "BO",  // Bolivian Boliviano
            "LSL": "LS",  // Lesotho Loti
            "MGA": "MG",  // Malagasy Ariary
            "KYD": "KY",  // Cayman Islands Dollar
            "PAB": "PA",  // Panamanian Balboa
            "FKP": "FK",  // Falkland Islands Pound
            "XPT": "XP",  // Platinum Ounce
            "SDG": "SD",  // Sudanese Pound
            "XOF": "XO",  // West African CFA Franc
            "WST": "WS",  // Samoan Tala
            "MZN": "MZ",  // Mozambican Metical
            "XAF": "XA",  // Central African CFA Franc
            "TWD": "TW",  // New Taiwan Dollar
            "EGP": "EG",  // Egyptian Pound
            "BSD": "BS",  // Bahamian Dollar
            "DOP": "DO",  // Dominican Peso
            "KHR": "KH",  // Cambodian Riel
            "SBD": "SB",  // Solomon Islands Dollar
            "BGN": "BG",  // Bulgarian Lev
            "ETB": "ET",  // Ethiopian Birr
            "AOA": "AO",  // Angolan Kwanza
            "AFN": "AF",  // Afghan Afghani
            "BTC": "BT",  // Bitcoin
            "RWF": "RW",  // Rwandan Franc
            "PGK": "PG",  // Papua New Guinean Kina
            "NIO": "NI",  // Nicaraguan Córdoba
            "CUC": "CU",  // Cuban Convertible Peso
            "GEL": "GE",  // Georgian Lari
            "AUD": "AU",  // Australian Dollar
            "MNT": "MN",  // Mongolian Tugrik
            "PHP": "PH",  // Philippine Peso
            "MVR": "MV",  // Maldivian Rufiyaa
            "KGS": "KG",  // Kyrgyzstani Som
            "IQD": "IQ",  // Iraqi Dinar
            "SCR": "SC",  // Seychellois Rupee
            "BWP": "BW",  // Botswanan Pula
            "UAH": "UA",  // Ukrainian Hryvnia
            "CNH": "CN",  // Chinese Yuan (Offshore)
            "VUV": "VU",  // Vanuatu Vatu
            "JMD": "JM",  // Jamaican Dollar
            "MDL": "MD",  // Moldovan Leu
            "CZK": "CZ",  // Czech Koruna
            "LKR": "LK",  // Sri Lankan Rupee
            "AZN": "AZ",  // Azerbaijani Manat
            "STD": "ST",  // São Tomé and Príncipe Dobra
            "MKD": "MK",  // Macedonian Denar
            "ALL": "AL",  // Albanian Lek
            "BTN": "BT",  // Bhutanese Ngultrum
            "VND": "VN",  // Vietnamese Dong
            "SSP": "SS",  // South Sudanese Pound
            "TMT": "TM",  // Turkmenistani Manat
            "ARS": "AR",  // Argentine Peso
            "KWD": "KW",  // Kuwaiti Dinar
            "SYP": "SY",  // Syrian Pound
            "ISK": "IS",  // Icelandic Króna
            "MUR": "MU",  // Mauritian Rupee
            "HTG": "HT",  // Haitian Gourde
            "DZD": "DZ",  // Algerian Dinar
            "CAD": "CA",  // Canadian Dollar
            "ZWL": "ZW",  // Zimbabwean Dollar
            "DKK": "DK",  // Danish Krone
            "GMD": "GM",  // Gambian Dalasi
            "HRK": "HR",  // Croatian Kuna
            "GHS": "GH",  // Ghanaian Cedi
            "LAK": "LA",  // Lao Kip
            "YER": "YE",  // Yemeni Rial
            "XAG": "XA",  // Silver Ounce
            "TTD": "TT",  // Trinidad and Tobago Dollar
            "KZT": "KZ",  // Kazakhstani Tenge
            "LRD": "LR",  // Liberian Dollar
            "DJF": "DJ",  // Djiboutian Franc
            "ZMW": "ZM",  // Zambian Kwacha
            "RSD": "RS",  // Serbian Dinar
            "BIF": "BI",  // Burundian Franc
            "GTQ": "GT",  // Guatemalan Quetzal
            "ZAR": "ZA",  // South African Rand
            "XPF": "PF",  // CFP Franc
            "CLP": "CL",  // Chilean Peso
            "BBD": "BB",  // Barbadian Dollar
            "HUF": "HU",  // Hungarian Forint
            "SLL": "SL",  // Sierra Leonean Leone
            "XDR": "XD",  // Special Drawing Rights
            "CLF": "CL",  // Chilean Unit of Account (UF)
            "BAM": "BA",  // Bosnia-Herzegovina Convertible Mark
            "SVC": "SV",  // Salvadoran Colón
            "CVE": "CV",  // Cape Verdean Escudo
            "IRR": "IR",  // Iranian Rial
            "MRU": "MR",  // Mauritanian Ouguiya
            "GYD": "GY"   // Guyanese Dollar
        ]
        
        return mapping[currencyCode]
    }
    
    private func currencyCodeToSymbol(_ currencyCode: String) -> String {
        let currencyMapping: [String: String] = [
            "USD": "$",    // United States Dollar
            "EUR": "€",    // Euro
            "JPY": "¥",    // Japanese Yen
            "GBP": "£",    // British Pound Sterling
            "CAD": "C$",   // Canadian Dollar
            "CHF": "CHF",  // Swiss Franc
            "CNY": "¥",    // Chinese Yuan
            "SEK": "kr",   // Swedish Krona
            "SGD": "S$",   // Singapore Dollar
            "HKD": "HK$",  // Hong Kong Dollar
            "NOK": "kr",   // Norwegian Krone
            "KRW": "₩",    // South Korean Won
            "TRY": "₺",    // Turkish Lira
            "RUB": "₽",    // Russian Ruble
            "INR": "₹",    // Indian Rupee
            "BRL": "R$",   // Brazilian Real
            "AED": "د.إ",  // UAE Dirham
            "SAR": "﷼",    // Saudi Riyal
            "QAR": "﷼",    // Qatari Rial
            "EGP": "£",    // Egyptian Pound
            "PKR": "₨",    // Pakistani Rupee
            "BDT": "৳",    // Bangladeshi Taka
            "IDR": "Rp",   // Indonesian Rupiah
            "PHP": "₱",    // Philippine Peso
            "VND": "₫",    // Vietnamese Dong
            "NGN": "₦",    // Nigerian Naira
            "KWD": "د.ك",  // Kuwaiti Dinar
            "BHD": "ب.د",  // Bahraini Dinar
            "OMR": "ر.ع.", // Omani Rial
            "MAD": "د.م.", // Moroccan Dirham
            "ILS": "₪",    // Israeli New Shekel
            "ARS": "$",    // Argentine Peso
            "CLP": "$",    // Chilean Peso
            "COP": "$",    // Colombian Peso
            "UYU": "$U",   // Uruguayan Peso
            "PEN": "S/.",  // Peruvian Sol
            "BOB": "Bs.",  // Bolivian Boliviano
            "PYG": "₲",    // Paraguayan Guarani
            "VEF": "Bs.",  // Venezuelan Bolívar
            "GHS": "₵",    // Ghanaian Cedi
            "KES": "KSh",  // Kenyan Shilling
            "TZS": "TSh",  // Tanzanian Shilling
            "UGX": "USh",  // Ugandan Shilling
            "RWF": "FRw",  // Rwandan Franc
            "MVR": "ރ.",  // Maldivian Rufiyaa
            "LKR": "₨",    // Sri Lankan Rupee
            "NPR": "₨",    // Nepalese Rupee
            "MMK": "K",    // Myanmar Kyat
            "KHR": "៛",    // Cambodian Riel
            "LAK": "₭",    // Lao Kip
            "BMD": "$",    // Bermudian Dollar
            "BSD": "$",    // Bahamian Dollar
            "TTD": "TT$",  // Trinidad and Tobago Dollar
            "BBD": "$",    // Barbadian Dollar
            "GIP": "£",    // Gibraltar Pound
            "SHP": "£",    // Saint Helena Pound
            "FKP": "£",    // Falkland Islands Pound
            "ANG": "ƒ",    // Netherlands Antillean Guilder
            "CUP": "₱",    // Cuban Peso
            "CUC": "$",    // Cuban Convertible Peso
            "KYD": "$",    // Cayman Islands Dollar
            "AWG": "ƒ",    // Aruban Florin
            "SRD": "$",    // Surinamese Dollar
            "BZD": "$",    // Belize Dollar
            "HTG": "G",    // Haitian Gourde
            "DOP": "RD$",  // Dominican Peso
            "ZWL": "Z$",   // Zimbabwean Dollar
            "MZN": "MT",   // Mozambican Metical
            "ETB": "Br",   // Ethiopian Birr
            "SLL": "Le",   // Sierra Leonean Leone
            "GNF": "FG",   // Guinean Franc
            "XCD": "$",    // East Caribbean Dollar
            "GMD": "D",    // Gambian Dalasi
            "BIF": "FBu",  // Burundian Franc
            "KMF": "CF",   // Comorian Franc
            "DJF": "Fdj",  // Djiboutian Franc
            "SOS": "Sh",   // Somali Shilling
            "CDF": "FC",   // Congolese Franc
            "AOA": "Kz",   // Angolan Kwanza
            "SDG": "ج.س.", // Sudanese Pound
            "SSP": "£",    // South Sudanese Pound
            "XAF": "FCFA", // Central African CFA Franc
            "XOF": "CFA",  // West African CFA Franc
            "BWP": "P",    // Botswanan Pula
            "NAD": "$",    // Namibian Dollar
            "ZAR": "R",    // South African Rand
            "MUR": "₨",    // Mauritian Rupee
            "SCR": "₨",    // Seychellois Rupee
            "MGA": "Ar",   // Malagasy Ariary
            "MWK": "MK",   // Malawian Kwacha
            "SZL": "L",    // Swazi Lilangeni
            "LSL": "L",    // Lesotho Loti
            "ZMW": "ZK",   // Zambian Kwacha
            "BND": "B$",   // Brunei Dollar
            "SBD": "$",    // Solomon Islands Dollar
            "FJD": "$",    // Fijian Dollar
            "TOP": "T$",   // Tongan Paʻanga
            "WST": "WS$",  // Samoan Tala
            "PGK": "K",    // Papua New Guinean Kina
            "VUV": "VT",   // Vanuatu Vatu
            "AUD": "A$",   // Australian Dollar
            "NZD": "NZ$",  // New Zealand Dollar
        ]
        
        
        return currencyMapping[currencyCode] ?? currencyCode
    }
    
}
