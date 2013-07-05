-- GSoC 2013 - Communicating with mobile devices.

{-# LANGUAGE OverloadedStrings, TypeFamilies, TemplateHaskell,
             QuasiQuotes, MultiParamTypeClasses, GeneralizedNewtypeDeriving, FlexibleContexts, GADTs #-}

import Types
import Constants

import Data.Convertible             (convert)
import Data.Default
import Data.Serialize
import Data.Text.Encoding           (encodeUtf8)
import Data.Text                    (unpack,pack)
import Data.Time.Clock.POSIX
import Data.Time.Clock
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as LB
import qualified Data.Aeson.Encode as AE
import Network.Connection
import Network.Socket.Internal      (PortNumber(PortNum))
import Network.TLS.Extra            (fileReadCertificate,fileReadPrivateKey)
import Network.TLS
import Data.Certificate.X509        (X509)

connParams :: X509 -> PrivateKey -> ConnectionParams
connParams cert privateKey = ConnectionParams{
                connectionHostname = "localhost"
            ,   connectionPort     = fromInteger 2195
            ,   connectionUseSecure = Just $ TLSSettings defaultParamsClient{-
                                             pCertificates = [(cert , Just privateKey)]
                                        ,    onHandshake        = \a -> do
                                                                            print a
                                                                            return True
                                        ,    onCertificatesRecv = \_ -> return CertificateUsageAccept
                                        ,    roleParams    = Client $ ClientParams{
                                                    clientWantSessionResume    = Nothing
                                                ,   clientUseMaxFragmentLength = Nothing
                                                ,   clientUseServerName        = Nothing
                                                ,   onCertificateRequest       = \x -> return True {-do
                                                                                           print x
                                                                                           return [(cert , Just privateKey)]-}
                                             }
                                        -}
            ,   connectionUseSocks = Nothing
            }

send :: IO ()
send = do
        ctime       <- getPOSIXTime
        cert        <- fileReadCertificate "public-cert.pem"
        key         <- fileReadPrivateKey "private-key.pem"
        cContext    <- initConnectionContext
        connection  <- connectTo cContext $ connParams cert key
        connectionPut connection $ runPut $ createPut def{deviceToken = "7518b1c2c7686d3b5dcac823231"} ctime


createPut :: APNSmessage -> NominalDiffTime -> Put
createPut msg ctime = do
   let
       btoken     = encodeUtf8 $ deviceToken msg -- I have to check if encodeUtf8 is the appropiate function.
       bpayload   = AE.encode msg
       expiryTime = case expiry msg of
                      Nothing ->  round (ctime + posixDayLength)-- One day for Default
                      Just t  ->  round (utcTimeToPOSIXSeconds t)
   --if (B.length btoken) /= 32
    --then fail "Invalid deviceToken"
   -- else
   if (LB.length bpayload > 256)
          then fail "Too long payload"
          else do
                putWord8 1
                putWord32be 10 --identifier
                putWord32be expiryTime
                putWord16be $ convert $ B.length btoken
                putByteString btoken
                putWord16be $ convert $ LB.length bpayload
                putLazyByteString bpayload