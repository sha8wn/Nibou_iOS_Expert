//
//  Constant.swift
//  FIFGROUP
//
//  Created by Himanshu Goyal on 23/10/18.
//  Copyright © 2018 Spice Labs Pvt Ltd. All rights reserved.
//

import Foundation

//MARK:- API Keys

// Basic

//DEV
//let kClientId                      = "KtqwLc20z1Elb1E2GWPfQSpxQTHg0Cc7H_xM_eYtDMo"
//let kClientSecret                  = "z0fp2Ng0dssdmkM18Dk8JL9PvTY-EczdrVeHjhk7eYk"

//PROD
let kClientId                      = "iNnhZW5zRjo9R67wrCaHEdnP51pvlaImOnpoTJOruek"
let kClientSecret                  = "YUtT7DMonOGRE9TC5rdQX5GOoRIFlkeNpZ4g_fx2ptM"
let kContentTypeKey                = "Content-Type"
let kContentTypeValueKey           = "application/json"
let kAuthorizationKey              = "Authorization"
let kAuthorizationValueKey         = "Basic RklGVXNlcjpGSUZVc2Vy"
let kSomethingWentWrongErrorCode   = 1000
let kInternetErrorCode             = 10001
let kServerTimeOut                 = 1001



let kSignUpAPi                     = "/users"
let kAccessToken                   = "/oauth/token"
let kChangePassword                = "/v1/users/me/password"
let kGetProfile                    = "/v1/users/me"
let kUpdateProfile                 = "/v1/users/me"
let kForgotPassword                = "/v1/users/password/change"
let kChatSession                   = "/v1/chat/rooms"
let kGetRoomDetails                = "/v1/chat/rooms/"
let kChatSendMessage               = "/v1/chat/message/"
let kGetChatHistory                = "/v1/chat/message/"
let kGetBookmark                   = "/v1/chat/message/%@/bookmarks"
let kUpdateBookmark                = "/v1/chat/message/%@/bookmarks"
let kGetTimings                    = "/v1/users/me/timings"
let kGetLanguageList               = "/v1/languages"
let kGetExpertiesList              = "/v1/expertises"
let kGetReviewList                 = "/v1/reviews"
let kFeedback                      = "/v1/feedbacks"
let kChatListSearch                = "/v1/chat/rooms/search?query="
let kSaveDeviceToken               = "/v1/users/me/devises"
let kGetOverallPayment             = "/v1/payments/overall"
let kGetMonthlyPayment             = "/v1/payments/month_total?date="
let kGetMonthPerDayPayment         = "/v1/payments/month_per_day?date="
let kGetDayPayment                 = "/v1/payments/by_day?"
let kGetOverallDay                 = "/v1/payments/overall_by_day?"
let kLogOut                        = "/v1/users/me/set_status"


//PRODUCTION
var kBaseURL                       = "https://api.nibouapp.com"
let kWebSocketURL                  = "wss://api.nibouapp.com/cable"

//Dev
//var kBaseURL                       = "https://api.staging.nibouapp.com"
//let kWebSocketURL                  = "wss://api.staging.nibouapp.com/cable"
