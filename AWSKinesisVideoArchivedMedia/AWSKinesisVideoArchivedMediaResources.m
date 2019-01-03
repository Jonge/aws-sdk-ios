//
// Copyright 2010-2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.
// A copy of the License is located at
//
// http://aws.amazon.com/apache2.0
//
// or in the "license" file accompanying this file. This file is distributed
// on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
// express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import "AWSKinesisVideoArchivedMediaResources.h"
#import <AWSCore/AWSCocoaLumberjack.h>

@interface AWSKinesisVideoArchivedMediaResources ()

@property (nonatomic, strong) NSDictionary *definitionDictionary;

@end

@implementation AWSKinesisVideoArchivedMediaResources

+ (instancetype)sharedInstance {
    static AWSKinesisVideoArchivedMediaResources *_sharedResources = nil;
    static dispatch_once_t once_token;

    dispatch_once(&once_token, ^{
        _sharedResources = [AWSKinesisVideoArchivedMediaResources new];
    });

    return _sharedResources;
}

- (NSDictionary *)JSONObject {
    return self.definitionDictionary;
}

- (instancetype)init {
    if (self = [super init]) {
        //init method
        NSError *error = nil;
        _definitionDictionary = [NSJSONSerialization JSONObjectWithData:[[self definitionString] dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:kNilOptions
                                                                  error:&error];
        if (_definitionDictionary == nil) {
            if (error) {
                AWSDDLogError(@"Failed to parse JSON service definition: %@",error);
            }
        }
    }
    return self;
}

- (NSString *)definitionString {
    return @"{\
  \"version\":\"2.0\",\
  \"metadata\":{\
    \"apiVersion\":\"2017-09-30\",\
    \"endpointPrefix\":\"kinesisvideo\",\
    \"protocol\":\"rest-json\",\
    \"serviceAbbreviation\":\"Kinesis Video Archived Media\",\
    \"serviceFullName\":\"Amazon Kinesis Video Streams Archived Media\",\
    \"serviceId\":\"Kinesis Video Archived Media\",\
    \"signatureVersion\":\"v4\",\
    \"uid\":\"kinesis-video-archived-media-2017-09-30\"\
  },\
  \"operations\":{\
    \"GetHLSStreamingSessionURL\":{\
      \"name\":\"GetHLSStreamingSessionURL\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/getHLSStreamingSessionURL\"\
      },\
      \"input\":{\"shape\":\"GetHLSStreamingSessionURLInput\"},\
      \"output\":{\"shape\":\"GetHLSStreamingSessionURLOutput\"},\
      \"errors\":[\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"InvalidArgumentException\"},\
        {\"shape\":\"ClientLimitExceededException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"UnsupportedStreamMediaTypeException\"},\
        {\"shape\":\"NoDataRetentionException\"},\
        {\"shape\":\"MissingCodecPrivateDataException\"},\
        {\"shape\":\"InvalidCodecPrivateDataException\"}\
      ],\
      \"documentation\":\"<p>Retrieves an HTTP Live Streaming (HLS) URL for the stream. The URL can then be opened in a browser or media player to view the stream contents.</p> <p>You must specify either the <code>StreamName</code> or the <code>StreamARN</code>.</p> <p>An Amazon Kinesis video stream has the following requirements for providing data through HLS:</p> <ul> <li> <p>The media type must be <code>video/h264</code>.</p> </li> <li> <p>Data retention must be greater than 0.</p> </li> <li> <p>The fragments must contain codec private data in the AVC (Advanced Video Coding) for H.264 format (<a href=\\\"https://www.iso.org/standard/55980.html\\\">MPEG-4 specification ISO/IEC 14496-15</a>). For information about adapting stream data to a given format, see <a href=\\\"http://docs.aws.amazon.com/kinesisvideostreams/latest/dg/latest/dg/producer-reference-nal.html\\\">NAL Adaptation Flags</a>.</p> </li> </ul> <p>Kinesis Video Streams HLS sessions contain fragments in the fragmented MPEG-4 form (also called fMP4 or CMAF), rather than the MPEG-2 form (also called TS chunks, which the HLS specification also supports). For more information about HLS fragment types, see the <a href=\\\"https://tools.ietf.org/html/draft-pantos-http-live-streaming-23\\\">HLS specification</a>.</p> <p>The following procedure shows how to use HLS with Kinesis Video Streams:</p> <ol> <li> <p>Get an endpoint using <a href=\\\"http://docs.aws.amazon.com/kinesisvideostreams/latest/dg/API_GetDataEndpoint.html\\\">GetDataEndpoint</a>, specifying <code>GET_HLS_STREAMING_SESSION_URL</code> for the <code>APIName</code> parameter.</p> </li> <li> <p>Retrieve the HLS URL using <code>GetHLSStreamingSessionURL</code>. Kinesis Video Streams creates an HLS streaming session to be used for accessing content in a stream using the HLS protocol. <code>GetHLSStreamingSessionURL</code> returns an authenticated URL (that includes an encrypted session token) for the session's HLS <i>master playlist</i> (the root resource needed for streaming with HLS).</p> <note> <p>Don't share or store this token where an unauthorized entity could access it. The token provides access to the content of the stream. Safeguard the token with the same measures that you would use with your AWS credentials.</p> </note> <p>The media that is made available through the playlist consists only of the requested stream, time range, and format. No other media data (such as frames outside the requested window or alternate bit rates) is made available.</p> </li> <li> <p>Provide the URL (containing the encrypted session token) for the HLS master playlist to a media player that supports the HLS protocol. Kinesis Video Streams makes the HLS media playlist, initialization fragment, and media fragments available through the master playlist URL. The initialization fragment contains the codec private data for the stream, and other data needed to set up the video decoder and renderer. The media fragments contain H.264-encoded video frames and time stamps.</p> </li> <li> <p>The media player receives the authenticated URL and requests stream metadata and media data normally. When the media player requests data, it calls the following actions:</p> <ul> <li> <p> <b>GetHLSMasterPlaylist:</b> Retrieves an HLS master playlist, which contains a URL for the <code>GetHLSMediaPlaylist</code> action, and additional metadata for the media player, including estimated bit rate and resolution.</p> </li> <li> <p> <b>GetHLSMediaPlaylist:</b> Retrieves an HLS media playlist, which contains a URL to access the MP4 intitialization fragment with the <code>GetMP4InitFragment</code> action, and URLs to access the MP4 media fragments with the <code>GetMP4MediaFragment</code> actions. The HLS media playlist also contains metadata about the stream that the player needs to play it, such as whether the <code>PlaybackMode</code> is <code>LIVE</code> or <code>ON_DEMAND</code>. The HLS media playlist is typically static for sessions with a <code>PlaybackType</code> of <code>ON_DEMAND</code>. The HLS media playlist is continually updated with new fragments for sessions with a <code>PlaybackType</code> of <code>LIVE</code>.</p> </li> <li> <p> <b>GetMP4InitFragment:</b> Retrieves the MP4 initialization fragment. The media player typically loads the initialization fragment before loading any media fragments. This fragment contains the \\\"<code>fytp</code>\\\" and \\\"<code>moov</code>\\\" MP4 atoms, and the child atoms that are needed to initialize the media player decoder.</p> <p>The initialization fragment does not correspond to a fragment in a Kinesis video stream. It contains only the codec private data for the stream, which the media player needs to decode video frames.</p> </li> <li> <p> <b>GetMP4MediaFragment:</b> Retrieves MP4 media fragments. These fragments contain the \\\"<code>moof</code>\\\" and \\\"<code>mdat</code>\\\" MP4 atoms and their child atoms, containing the encoded fragment's video frames and their time stamps.</p> <note> <p>After the first media fragment is made available in a streaming session, any fragments that don't contain the same codec private data are excluded in the HLS media playlist. Therefore, the codec private data does not change between fragments in a session.</p> </note> </li> </ul> </li> </ol> <note> <p>The following restrictions apply to HLS sessions:</p> <ul> <li> <p>A streaming session URL should not be shared between players. The service might throttle a session if multiple media players are sharing it. For connection limits, see <a href=\\\"http://docs.aws.amazon.com/kinesisvideostreams/latest/dg/limits.html\\\">Kinesis Video Streams Limits</a>.</p> </li> <li> <p>A Kinesis video stream can have a maximum of five active HLS streaming sessions. If a new session is created when the maximum number of sessions is already active, the oldest (earliest created) session is closed. The number of active <code>GetMedia</code> connections on a Kinesis video stream does not count against this limit, and the number of active HLS sessions does not count against the active <code>GetMedia</code> connection limit.</p> </li> </ul> </note> <p>You can monitor the amount of data that the media player consumes by monitoring the <code>GetMP4MediaFragment.OutgoingBytes</code> Amazon CloudWatch metric. For information about using CloudWatch to monitor Kinesis Video Streams, see <a href=\\\"http://docs.aws.amazon.com/kinesisvideostreams/latest/dg/monitoring.html\\\">Monitoring Kinesis Video Streams</a>. For pricing information, see <a href=\\\"https://aws.amazon.com/kinesis/video-streams/pricing/\\\">Amazon Kinesis Video Streams Pricing</a> and <a href=\\\"https://aws.amazon.com/pricing/\\\">AWS Pricing</a>. Charges for both HLS sessions and outgoing AWS data apply.</p> <p>For more information about HLS, see <a href=\\\"https://developer.apple.com/streaming/\\\">HTTP Live Streaming</a> on the <a href=\\\"https://developer.apple.com\\\">Apple Developer site</a>.</p>\"\
    },\
    \"GetMediaForFragmentList\":{\
      \"name\":\"GetMediaForFragmentList\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/getMediaForFragmentList\"\
      },\
      \"input\":{\"shape\":\"GetMediaForFragmentListInput\"},\
      \"output\":{\"shape\":\"GetMediaForFragmentListOutput\"},\
      \"errors\":[\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"InvalidArgumentException\"},\
        {\"shape\":\"ClientLimitExceededException\"},\
        {\"shape\":\"NotAuthorizedException\"}\
      ],\
      \"documentation\":\"<p>Gets media for a list of fragments (specified by fragment number) from the archived data in an Amazon Kinesis video stream.</p> <p>The following limits apply when using the <code>GetMediaForFragmentList</code> API:</p> <ul> <li> <p>A client can call <code>GetMediaForFragmentList</code> up to five times per second per stream. </p> </li> <li> <p>Kinesis Video Streams sends media data at a rate of up to 25 megabytes per second (or 200 megabits per second) during a <code>GetMediaForFragmentList</code> session. </p> </li> </ul>\"\
    },\
    \"ListFragments\":{\
      \"name\":\"ListFragments\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/listFragments\"\
      },\
      \"input\":{\"shape\":\"ListFragmentsInput\"},\
      \"output\":{\"shape\":\"ListFragmentsOutput\"},\
      \"errors\":[\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"InvalidArgumentException\"},\
        {\"shape\":\"ClientLimitExceededException\"},\
        {\"shape\":\"NotAuthorizedException\"}\
      ],\
      \"documentation\":\"<p>Returns a list of <a>Fragment</a> objects from the specified stream and start location within the archived data.</p>\"\
    }\
  },\
  \"shapes\":{\
    \"ClientLimitExceededException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Message\":{\"shape\":\"ErrorMessage\"}\
      },\
      \"documentation\":\"<p>Kinesis Video Streams has throttled the request because you have exceeded the limit of allowed client calls. Try making the call later.</p>\",\
      \"error\":{\"httpStatusCode\":400},\
      \"exception\":true\
    },\
    \"ContentType\":{\
      \"type\":\"string\",\
      \"max\":128,\
      \"min\":1,\
      \"pattern\":\"^[a-zA-Z0-9_\\\\.\\\\-]+$\"\
    },\
    \"DiscontinuityMode\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"ALWAYS\",\
        \"NEVER\"\
      ]\
    },\
    \"ErrorMessage\":{\"type\":\"string\"},\
    \"Expires\":{\
      \"type\":\"integer\",\
      \"max\":43200,\
      \"min\":300\
    },\
    \"Fragment\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"FragmentNumber\":{\
          \"shape\":\"String\",\
          \"documentation\":\"<p>The index value of the fragment.</p>\"\
        },\
        \"FragmentSizeInBytes\":{\
          \"shape\":\"Long\",\
          \"documentation\":\"<p>The total fragment size, including information about the fragment and contained media data.</p>\"\
        },\
        \"ProducerTimestamp\":{\
          \"shape\":\"Timestamp\",\
          \"documentation\":\"<p>The time stamp from the producer corresponding to the fragment.</p>\"\
        },\
        \"ServerTimestamp\":{\
          \"shape\":\"Timestamp\",\
          \"documentation\":\"<p>The time stamp from the AWS server corresponding to the fragment.</p>\"\
        },\
        \"FragmentLengthInMilliseconds\":{\
          \"shape\":\"Long\",\
          \"documentation\":\"<p>The playback duration or other time value associated with the fragment.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Represents a segment of video or other time-delimited data.</p>\"\
    },\
    \"FragmentList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"Fragment\"}\
    },\
    \"FragmentNumberList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"FragmentNumberString\"},\
      \"max\":1000,\
      \"min\":1\
    },\
    \"FragmentNumberString\":{\
      \"type\":\"string\",\
      \"max\":128,\
      \"min\":1,\
      \"pattern\":\"^[0-9]+$\"\
    },\
    \"FragmentSelector\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"FragmentSelectorType\",\
        \"TimestampRange\"\
      ],\
      \"members\":{\
        \"FragmentSelectorType\":{\
          \"shape\":\"FragmentSelectorType\",\
          \"documentation\":\"<p>The origin of the time stamps to use (Server or Producer).</p>\"\
        },\
        \"TimestampRange\":{\
          \"shape\":\"TimestampRange\",\
          \"documentation\":\"<p>The range of time stamps to return.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Describes the time stamp range and time stamp origin of a range of fragments.</p>\"\
    },\
    \"FragmentSelectorType\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"PRODUCER_TIMESTAMP\",\
        \"SERVER_TIMESTAMP\"\
      ]\
    },\
    \"GetHLSStreamingSessionURLInput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"StreamName\":{\
          \"shape\":\"StreamName\",\
          \"documentation\":\"<p>The name of the stream for which to retrieve the HLS master playlist URL.</p> <p>You must specify either the <code>StreamName</code> or the <code>StreamARN</code>.</p>\"\
        },\
        \"StreamARN\":{\
          \"shape\":\"ResourceARN\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the stream for which to retrieve the HLS master playlist URL.</p> <p>You must specify either the <code>StreamName</code> or the <code>StreamARN</code>.</p>\"\
        },\
        \"PlaybackMode\":{\
          \"shape\":\"PlaybackMode\",\
          \"documentation\":\"<p>Whether to retrieve live or archived, on-demand data.</p> <p>Features of the two types of session include the following:</p> <ul> <li> <p> <b> <code>LIVE</code> </b>: For sessions of this type, the HLS media playlist is continually updated with the latest fragments as they become available. We recommend that the media player retrieve a new playlist on a one-second interval. When this type of session is played in a media player, the user interface typically displays a \\\"live\\\" notification, with no scrubber control for choosing the position in the playback window to display.</p> <note> <p>In <code>LIVE</code> mode, the newest available fragments are included in an HLS media playlist, even if there is a gap between fragments (that is, if a fragment is missing). A gap like this might cause a media player to halt or cause a jump in playback. In this mode, fragments are not added to the HLS media playlist if they are older than the newest fragment in the playlist. If the missing fragment becomes available after a subsequent fragment is added to the playlist, the older fragment is not added, and the gap is not filled.</p> </note> </li> <li> <p> <b> <code>ON_DEMAND</code> </b>: For sessions of this type, the HLS media playlist contains all the fragments for the session, up to the number that is specified in <code>MaxMediaPlaylistFragmentResults</code>. The playlist must be retrieved only once for each session. When this type of session is played in a media player, the user interface typically displays a scrubber control for choosing the position in the playback window to display.</p> <note> <p>The duration of the fragments in the HLS media playlists is typically reported as short by one frame (for example, 33 milliseconds for a 30 FPS fragment). This might cause the media player to report a shorter total duration until the media player decodes the fragments.</p> </note> </li> </ul> <p>In both playback modes, if there are multiple fragments with the same start time stamp, the fragment that has the larger fragment number (that is, the newer fragment) is included in the HLS media playlist. The other fragments are not included. Fragments that have different time stamps but have overlapping durations are still included in the HLS media playlist. This can lead to unexpected behavior in the media player.</p> <p>The default is <code>LIVE</code>.</p>\"\
        },\
        \"HLSFragmentSelector\":{\
          \"shape\":\"HLSFragmentSelector\",\
          \"documentation\":\"<p>The time range of the requested fragment, and the source of the time stamp.</p> <p>This parameter is required if <code>PlaybackMode</code> is <code>ON_DEMAND</code>. This parameter is optional if <code>PlaybackMode</code> is <code>LIVE</code>. If <code>PlaybackMode</code> is <code>LIVE</code>, the <code>FragmentSelectorType</code> can be set, but the <code>TimestampRange</code> should not be set.</p>\"\
        },\
        \"DiscontinuityMode\":{\"shape\":\"DiscontinuityMode\"},\
        \"Expires\":{\
          \"shape\":\"Expires\",\
          \"documentation\":\"<p>The time in seconds until the requested session expires. This value can be between 300 (5 minutes) and 43200 (12 hours).</p> <p>When a session expires, no new calls to <code>GetHLSMasterPlaylist</code>, <code>GetHLSMediaPlaylist</code>, <code>GetMP4InitFragment</code>, or <code>GetMP4MediaFragment</code> can be made for that session.</p> <p>The default is 3600 (one hour).</p>\"\
        },\
        \"MaxMediaPlaylistFragmentResults\":{\
          \"shape\":\"PageLimit\",\
          \"documentation\":\"<p>The maximum number of fragments that Kinesis Video Streams will return.</p> <p>When the <code>PlaybackMode</code> is <code>LIVE</code>, the most recent fragments are returned up to this value. When the <code>PlaybackMode</code> is <code>ON_DEMAND</code>, the oldest fragments are returned, up to this maximum number.</p> <p>When there are more fragments available in a live HLS media playlist, video players often buffer content before starting playback. Increasing the buffer size increases the playback latency, but it decreases the likelihood that rebuffering will occur during playback. We recommend that a live HLS media playlist have a minimum of 3 fragments and a maximum of 10 fragments.</p> <p>The default is 5 fragments if <code>PlaybackMode</code> is <code>LIVE</code>, and 1000 if <code>PlaybackMode</code> is <code>ON_DEMAND</code>. </p> <p>The maximum value of 1000 fragments corresponds to more than 16 minutes of video on streams with one-second fragments, and more than 2 1/2 hours of video on streams with ten-second fragments.</p>\"\
        }\
      }\
    },\
    \"GetHLSStreamingSessionURLOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"HLSStreamingSessionURL\":{\
          \"shape\":\"HLSStreamingSessionURL\",\
          \"documentation\":\"<p>The URL (containing the session token) that a media player can use to retrieve the HLS master playlist.</p>\"\
        }\
      }\
    },\
    \"GetMediaForFragmentListInput\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"StreamName\",\
        \"Fragments\"\
      ],\
      \"members\":{\
        \"StreamName\":{\
          \"shape\":\"StreamName\",\
          \"documentation\":\"<p>The name of the stream from which to retrieve fragment media.</p>\"\
        },\
        \"Fragments\":{\
          \"shape\":\"FragmentNumberList\",\
          \"documentation\":\"<p>A list of the numbers of fragments for which to retrieve media. You retrieve these values with <a>ListFragments</a>.</p>\"\
        }\
      }\
    },\
    \"GetMediaForFragmentListOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ContentType\":{\
          \"shape\":\"ContentType\",\
          \"documentation\":\"<p>The content type of the requested media.</p>\",\
          \"location\":\"header\",\
          \"locationName\":\"Content-Type\"\
        },\
        \"Payload\":{\
          \"shape\":\"Payload\",\
          \"documentation\":\"<p>The payload that Kinesis Video Streams returns is a sequence of chunks from the specified stream. For information about the chunks, see <a href=\\\"http://docs.aws.amazon.com/kinesisvideostreams/latest/dg/API_dataplane_PutMedia.html\\\">PutMedia</a>. The chunks that Kinesis Video Streams returns in the <code>GetMediaForFragmentList</code> call also include the following additional Matroska (MKV) tags: </p> <ul> <li> <p>AWS_KINESISVIDEO_FRAGMENT_NUMBER - Fragment number returned in the chunk.</p> </li> <li> <p>AWS_KINESISVIDEO_SERVER_SIDE_TIMESTAMP - Server-side time stamp of the fragment.</p> </li> <li> <p>AWS_KINESISVIDEO_PRODUCER_SIDE_TIMESTAMP - Producer-side time stamp of the fragment.</p> </li> </ul> <p>The following tags will be included if an exception occurs:</p> <ul> <li> <p>AWS_KINESISVIDEO_FRAGMENT_NUMBER - The number of the fragment that threw the exception</p> </li> <li> <p>AWS_KINESISVIDEO_EXCEPTION_ERROR_CODE - The integer code of the exception</p> </li> <li> <p>AWS_KINESISVIDEO_EXCEPTION_MESSAGE - A text description of the exception</p> </li> </ul>\"\
        }\
      },\
      \"payload\":\"Payload\"\
    },\
    \"HLSFragmentSelector\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"FragmentSelectorType\":{\
          \"shape\":\"HLSFragmentSelectorType\",\
          \"documentation\":\"<p>The source of the time stamps for the requested media.</p> <p>The default is <code>PRODUCER_TIMESTAMP</code>.</p>\"\
        },\
        \"TimestampRange\":{\
          \"shape\":\"HLSTimestampRange\",\
          \"documentation\":\"<p>The start and end of the time stamp range for the requested media.</p> <p>This value should not be present if <code>PlaybackType</code> is <code>LIVE</code>.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Contains the range of time stamps for the requested media, and the source of the time stamps.</p>\"\
    },\
    \"HLSFragmentSelectorType\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"PRODUCER_TIMESTAMP\",\
        \"SERVER_TIMESTAMP\"\
      ]\
    },\
    \"HLSStreamingSessionURL\":{\"type\":\"string\"},\
    \"HLSTimestampRange\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"StartTimestamp\":{\
          \"shape\":\"Timestamp\",\
          \"documentation\":\"<p>The start of the time stamp range for the requested media.</p> <p>If the <code>HLSTimestampRange</code> value is specified, the <code>StartTimestamp</code> value is required.</p> <note> <p>This value is inclusive. Fragments that start before the <code>StartingTimestamp</code> and continue past it are included in the session.</p> </note>\"\
        },\
        \"EndTimestamp\":{\
          \"shape\":\"Timestamp\",\
          \"documentation\":\"<p>The end of the time stamp range for the requested media. This value must be within three hours of the specified <code>StartTimestamp</code>, and it must be later than the <code>StartTimestamp</code> value.</p> <p>If <code>FragmentSelectorType</code> for the request is <code>SERVER_TIMESTAMP</code>, this value must be in the past.</p> <p>If the <code>HLSTimestampRange</code> value is specified, the <code>EndTimestamp</code> value is required.</p> <note> <p>This value is inclusive. The <code>EndTimestamp</code> is compared to the (starting) time stamp of the fragment. Fragments that start before the <code>EndTimestamp</code> value and continue past it are included in the session.</p> </note>\"\
        }\
      },\
      \"documentation\":\"<p>The start and end of the time stamp range for the requested media.</p> <p>This value should not be present if <code>PlaybackType</code> is <code>LIVE</code>.</p> <note> <p>The values in the <code>HLSTimestampRange</code> are inclusive. Fragments that begin before the start time but continue past it, or fragments that begin before the end time but continue past it, are included in the session.</p> </note>\"\
    },\
    \"InvalidArgumentException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Message\":{\"shape\":\"ErrorMessage\"}\
      },\
      \"documentation\":\"<p>A specified parameter exceeds its restrictions, is not supported, or can't be used.</p>\",\
      \"error\":{\"httpStatusCode\":400},\
      \"exception\":true\
    },\
    \"InvalidCodecPrivateDataException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Message\":{\"shape\":\"ErrorMessage\"}\
      },\
      \"error\":{\"httpStatusCode\":400},\
      \"exception\":true\
    },\
    \"ListFragmentsInput\":{\
      \"type\":\"structure\",\
      \"required\":[\"StreamName\"],\
      \"members\":{\
        \"StreamName\":{\
          \"shape\":\"StreamName\",\
          \"documentation\":\"<p>The name of the stream from which to retrieve a fragment list.</p>\"\
        },\
        \"MaxResults\":{\
          \"shape\":\"PageLimit\",\
          \"documentation\":\"<p>The total number of fragments to return. If the total number of fragments available is more than the value specified in <code>max-results</code>, then a <a>ListFragmentsOutput$NextToken</a> is provided in the output that you can use to resume pagination.</p>\"\
        },\
        \"NextToken\":{\
          \"shape\":\"String\",\
          \"documentation\":\"<p>A token to specify where to start paginating. This is the <a>ListFragmentsOutput$NextToken</a> from a previously truncated response.</p>\"\
        },\
        \"FragmentSelector\":{\
          \"shape\":\"FragmentSelector\",\
          \"documentation\":\"<p>Describes the time stamp range and time stamp origin for the range of fragments to return.</p>\"\
        }\
      }\
    },\
    \"ListFragmentsOutput\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Fragments\":{\
          \"shape\":\"FragmentList\",\
          \"documentation\":\"<p>A list of fragment numbers that correspond to the time stamp range provided.</p>\"\
        },\
        \"NextToken\":{\
          \"shape\":\"String\",\
          \"documentation\":\"<p>If the returned list is truncated, the operation returns this token to use to retrieve the next page of results. This value is <code>null</code> when there are no more results to return.</p>\"\
        }\
      }\
    },\
    \"Long\":{\"type\":\"long\"},\
    \"MissingCodecPrivateDataException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Message\":{\"shape\":\"ErrorMessage\"}\
      },\
      \"error\":{\"httpStatusCode\":400},\
      \"exception\":true\
    },\
    \"NoDataRetentionException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Message\":{\"shape\":\"ErrorMessage\"}\
      },\
      \"documentation\":\"<p>A <code>PlaybackMode</code> of <code>ON_DEMAND</code> was requested for a stream that does not retain data (that is, has a <code>DataRetentionInHours</code> of 0). </p>\",\
      \"error\":{\"httpStatusCode\":400},\
      \"exception\":true\
    },\
    \"NotAuthorizedException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Message\":{\"shape\":\"ErrorMessage\"}\
      },\
      \"documentation\":\"<p>Status Code: 403, The caller is not authorized to perform an operation on the given stream, or the token has expired.</p>\",\
      \"error\":{\"httpStatusCode\":401},\
      \"exception\":true\
    },\
    \"PageLimit\":{\
      \"type\":\"long\",\
      \"max\":1000,\
      \"min\":1\
    },\
    \"Payload\":{\
      \"type\":\"blob\",\
      \"streaming\":true\
    },\
    \"PlaybackMode\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"LIVE\",\
        \"ON_DEMAND\"\
      ]\
    },\
    \"ResourceARN\":{\
      \"type\":\"string\",\
      \"max\":1024,\
      \"min\":1,\
      \"pattern\":\"arn:aws:kinesisvideo:[a-z0-9-]+:[0-9]+:[a-z]+/[a-zA-Z0-9_.-]+/[0-9]+\"\
    },\
    \"ResourceNotFoundException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Message\":{\"shape\":\"ErrorMessage\"}\
      },\
      \"documentation\":\"<p> <code>GetMedia</code> throws this error when Kinesis Video Streams can't find the stream that you specified.</p> <p> <code>GetHLSStreamingSessionURL</code> throws this error if a session with a <code>PlaybackMode</code> of <code>ON_DEMAND</code> is requested for a stream that has no fragments within the requested time range, or if a session with a <code>PlaybackMode</code> of <code>LIVE</code> is requested for a stream that has no fragments within the last 30 seconds.</p>\",\
      \"error\":{\"httpStatusCode\":404},\
      \"exception\":true\
    },\
    \"StreamName\":{\
      \"type\":\"string\",\
      \"max\":256,\
      \"min\":1,\
      \"pattern\":\"[a-zA-Z0-9_.-]+\"\
    },\
    \"String\":{\
      \"type\":\"string\",\
      \"min\":1\
    },\
    \"Timestamp\":{\"type\":\"timestamp\"},\
    \"TimestampRange\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"StartTimestamp\",\
        \"EndTimestamp\"\
      ],\
      \"members\":{\
        \"StartTimestamp\":{\
          \"shape\":\"Timestamp\",\
          \"documentation\":\"<p>The starting time stamp in the range of time stamps for which to return fragments.</p>\"\
        },\
        \"EndTimestamp\":{\
          \"shape\":\"Timestamp\",\
          \"documentation\":\"<p>The ending time stamp in the range of time stamps for which to return fragments.</p>\"\
        }\
      },\
      \"documentation\":\"<p>The range of time stamps for which to return fragments.</p>\"\
    },\
    \"UnsupportedStreamMediaTypeException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Message\":{\"shape\":\"ErrorMessage\"}\
      },\
      \"documentation\":\"<p>An HLS streaming session was requested for a stream with a media type that is not <code>video/h264</code>.</p>\",\
      \"error\":{\"httpStatusCode\":400},\
      \"exception\":true\
    }\
  },\
  \"documentation\":\"<p/>\"\
}\
";
}

@end
