# Catapult

Catapult is an extendable sharing framework that lets you pick and choose which services you want to share to.
Currently only supports action sheets, but can support UIActivities in the future.

#### Podfile

```ruby
platform :ios, '5.0'
pod "Catapult", "~> 0.1"
pod "Catapult-Tumblr", "~>0.1"
pod "Catapult-Pinterest", "~>0.1"
pod "Catapult-Facebook", "~>0.1"
```

## Registering Targets

You can register targets with the following code

```objective-c
[[Catapult shared] registerTarget:CFacebookTarget.class];
[[Catapult shared] registerTarget:CTwitterTarget.class];
[[Catapult shared] registerTarget:CWhatsAppTarget.class];
[[Catapult shared] registerTarget:CSMSTarget.class];
[[Catapult shared] registerTarget:CEmailTarget.class];
[[Catapult shared] registerTarget:CGmailTarget.class];
```

## Sharing

Sharing is as simple as generating a Payload and sending it to Catapult

```objective-c
CatapultPayload *payload = [[CatapultPayload alloc] init];
payload.text = @"SHARING IS AWESOME";
payload.url = [NSURL URLWithString:@"YAHOO"];
payload.imageURL = [NSURL URLWithString:@"http://myimageISCOOL.com"];
                
[[Catapult shared] takeAimWithPayload:payload
                     fromViewController:viewController
                            withOptions:@{}
                            andComplete:^(BOOL success, __unsafe_unretained Class<CatapultTarget> selectedTarget) {
    
}];
```

In this case, only targets that require text, url or imageUrl will be shown.

## Adding your own Target

Catapult is very extendable, to set up your own target you just need to conform to the CatapultTarget protocol

```objective-c
@protocol CatapultTarget <NSObject>
+ (CatapultTargetType)targetType;
+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete;
+ (NSString *)targetName;
+ (BOOL)canHandle;
+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source;
@end
```

## Credits

Catapult was originally created by [Jeff Friesen](https://github.com/robotafterall) in the development of Apps for [Tipping Canoe](https://github.com/TippingCanoe).

## License

Catapult is available under the MIT license. See the LICENSE file for more info.
