--
-- PostgreSQL database dump
--

\restrict dGpOD1qbgpUc3Y1m1JBR6MXLjdL6ZBKBSrQFaaLaIFrOZuV7NQTA078jxtG1Bwa

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.0

-- Started on 2026-06-11 09:44:39

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 228 (class 1259 OID 16833)
-- Name: alert; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alert (
    id character(36) NOT NULL,
    name character varying(255) NOT NULL,
    alert text NOT NULL
);


ALTER TABLE public.alert OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16778)
-- Name: channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.channel (
    id character(36) NOT NULL,
    name character varying(40) NOT NULL,
    revision integer,
    channel text
);


ALTER TABLE public.channel OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16875)
-- Name: channel_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.channel_group (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    revision integer,
    channel_group text
);


ALTER TABLE public.channel_group OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16856)
-- Name: code_template; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.code_template (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    revision integer,
    code_template text
);


ALTER TABLE public.code_template OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16845)
-- Name: code_template_library; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.code_template_library (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    revision integer,
    library text
);


ALTER TABLE public.code_template_library OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16866)
-- Name: configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.configuration (
    category character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.configuration OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16865)
-- Name: configuration_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.configuration_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.configuration_sequence OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16895)
-- Name: d_channels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.d_channels (
    local_channel_id bigint NOT NULL,
    channel_id character varying(36) NOT NULL
);


ALTER TABLE public.d_channels OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16905)
-- Name: d_m1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.d_m1 (
    id bigint NOT NULL,
    server_id character varying(36) NOT NULL,
    received_date timestamp with time zone,
    processed boolean DEFAULT false NOT NULL,
    original_id bigint,
    import_id bigint,
    import_channel_id character varying(36)
);


ALTER TABLE public.d_m1 OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16970)
-- Name: d_ma1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.d_ma1 (
    id character varying(255) NOT NULL,
    message_id bigint NOT NULL,
    type character varying(40),
    segment_id integer NOT NULL,
    attachment_size integer NOT NULL,
    content bytea,
    encryption_header text
);


ALTER TABLE public.d_ma1 OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16941)
-- Name: d_mc1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.d_mc1 (
    metadata_id integer NOT NULL,
    message_id bigint NOT NULL,
    content_type integer NOT NULL,
    content text,
    is_encrypted boolean NOT NULL,
    data_type character varying(255)
);


ALTER TABLE public.d_mc1 OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16958)
-- Name: d_mcm1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.d_mcm1 (
    metadata_id integer NOT NULL,
    message_id bigint NOT NULL,
    "SOURCE" character varying(255),
    "TYPE" character varying(255)
);


ALTER TABLE public.d_mcm1 OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16915)
-- Name: d_mm1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.d_mm1 (
    id integer NOT NULL,
    message_id bigint NOT NULL,
    server_id character varying(36) NOT NULL,
    received_date timestamp with time zone,
    status character(1) NOT NULL,
    connector_name text,
    send_attempts integer DEFAULT 0 NOT NULL,
    send_date timestamp with time zone,
    response_date timestamp with time zone,
    error_code integer DEFAULT 0 NOT NULL,
    chain_id integer NOT NULL,
    order_id integer NOT NULL
);


ALTER TABLE public.d_mm1 OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16986)
-- Name: d_ms1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.d_ms1 (
    metadata_id integer,
    server_id character varying(36) NOT NULL,
    received bigint DEFAULT 0 NOT NULL,
    received_lifetime bigint DEFAULT 0 NOT NULL,
    filtered bigint DEFAULT 0 NOT NULL,
    filtered_lifetime bigint DEFAULT 0 NOT NULL,
    sent bigint DEFAULT 0 NOT NULL,
    sent_lifetime bigint DEFAULT 0 NOT NULL,
    error bigint DEFAULT 0 NOT NULL,
    error_lifetime bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.d_ms1 OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 17007)
-- Name: d_msq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.d_msq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.d_msq1 OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16886)
-- Name: debug_usage_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.debug_usage_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.debug_usage_sequence OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16887)
-- Name: debugger_usage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.debugger_usage (
    id integer DEFAULT nextval('public.debug_usage_sequence'::regclass) NOT NULL,
    server_id character varying(50) NOT NULL,
    dupp_count integer,
    attach_batch_count integer,
    source_connector_count integer,
    source_filter_trans_count integer,
    destination_filter_trans_count integer,
    destination_connector_count integer,
    response_count integer,
    invocation_count integer
);


ALTER TABLE public.debugger_usage OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16764)
-- Name: event_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.event_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.event_sequence OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16765)
-- Name: event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event (
    id integer DEFAULT nextval('public.event_sequence'::regclass) NOT NULL,
    date_created timestamp with time zone,
    name text NOT NULL,
    event_level character varying(40) NOT NULL,
    outcome character varying(40) NOT NULL,
    attributes text,
    user_id integer NOT NULL,
    ip_address character varying(40),
    server_id character varying(36)
);


ALTER TABLE public.event OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16796)
-- Name: person_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.person_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.person_sequence OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16797)
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    id integer DEFAULT nextval('public.person_sequence'::regclass) NOT NULL,
    username character varying(40) NOT NULL,
    firstname character varying(40),
    lastname character varying(40),
    organization character varying(255),
    industry character varying(255),
    email character varying(255),
    phonenumber character varying(40),
    description character varying(255),
    last_login timestamp with time zone,
    grace_period_start timestamp with time zone,
    strike_count integer,
    last_strike_time timestamp with time zone,
    logged_in boolean NOT NULL,
    role character varying(40),
    country character varying(40),
    stateterritory character varying(40),
    userconsent boolean DEFAULT false NOT NULL
);


ALTER TABLE public.person OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16823)
-- Name: person_password; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_password (
    person_id integer NOT NULL,
    password character varying(255) NOT NULL,
    password_date timestamp with time zone
);


ALTER TABLE public.person_password OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16810)
-- Name: person_preference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_preference (
    person_id integer NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.person_preference OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16761)
-- Name: schema_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_info (
    version character varying(40)
);


ALTER TABLE public.schema_info OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16787)
-- Name: script; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.script (
    group_id character varying(40) NOT NULL,
    id character varying(40) NOT NULL,
    script text
);


ALTER TABLE public.script OWNER TO postgres;

--
-- TOC entry 5161 (class 0 OID 16833)
-- Dependencies: 228
-- Data for Name: alert; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5155 (class 0 OID 16778)
-- Dependencies: 222
-- Data for Name: channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.channel VALUES ('bc082c4b-db17-4e8f-9666-b96a1e9a9822', 'FHIR_CheckIn_Receiver', 25, '<channel version="4.5.2">
  <id>bc082c4b-db17-4e8f-9666-b96a1e9a9822</id>
  <nextMetaDataId>2</nextMetaDataId>
  <name>FHIR_CheckIn_Receiver</name>
  <description></description>
  <revision>25</revision>
  <sourceConnector version="4.5.2">
    <metaDataId>0</metaDataId>
    <name>sourceConnector</name>
    <properties class="com.mirth.connect.connectors.http.HttpReceiverProperties" version="4.5.2">
      <pluginProperties>
        <com.mirth.connect.plugins.httpauth.NoneHttpAuthProperties version="4.5.2">
  <authType>NONE</authType>
        </com.mirth.connect.plugins.httpauth.NoneHttpAuthProperties>
      </pluginProperties>
      <listenerConnectorProperties version="4.5.2">
        <host>0.0.0.0</host>
        <port>8081</port>
      </listenerConnectorProperties>
      <sourceConnectorProperties version="4.5.2">
        <responseVariable>None</responseVariable>
        <respondAfterProcessing>true</respondAfterProcessing>
        <processBatch>false</processBatch>
        <firstResponse>false</firstResponse>
        <processingThreads>1</processingThreads>
        <resourceIds class="linked-hash-map">
          <entry>
            <string>Default Resource</string>
            <string>[Default Resource]</string>
          </entry>
        </resourceIds>
        <queueBufferSize>1000</queueBufferSize>
      </sourceConnectorProperties>
      <xmlBody>false</xmlBody>
      <parseMultipart>true</parseMultipart>
      <includeMetadata>false</includeMetadata>
      <binaryMimeTypes>application/.*(?&lt;!json|xml)$|image/.*|video/.*|audio/.*</binaryMimeTypes>
      <binaryMimeTypesRegex>true</binaryMimeTypesRegex>
      <responseContentType>text/plain</responseContentType>
      <responseDataTypeBinary>false</responseDataTypeBinary>
      <responseStatusCode></responseStatusCode>
      <responseHeaders class="linked-hash-map"/>
      <responseHeadersVariable></responseHeadersVariable>
      <useResponseHeadersVariable>false</useResponseHeadersVariable>
      <charset>UTF-8</charset>
      <contextPath>fhir-receiver</contextPath>
      <timeout>60000</timeout>
      <staticResources/>
    </properties>
    <transformer version="4.5.2">
      <elements/>
      <inboundTemplate encoding="base64"></inboundTemplate>
      <outboundTemplate encoding="base64"></outboundTemplate>
      <inboundDataType>RAW</inboundDataType>
      <outboundDataType>RAW</outboundDataType>
      <inboundProperties class="com.mirth.connect.plugins.datatypes.raw.RawDataTypeProperties" version="4.5.2">
        <batchProperties class="com.mirth.connect.plugins.datatypes.raw.RawBatchProperties" version="4.5.2">
          <splitType>JavaScript</splitType>
          <batchScript></batchScript>
        </batchProperties>
      </inboundProperties>
      <outboundProperties class="com.mirth.connect.plugins.datatypes.raw.RawDataTypeProperties" version="4.5.2">
        <batchProperties class="com.mirth.connect.plugins.datatypes.raw.RawBatchProperties" version="4.5.2">
          <splitType>JavaScript</splitType>
          <batchScript></batchScript>
        </batchProperties>
      </outboundProperties>
    </transformer>
    <filter version="4.5.2">
      <elements/>
    </filter>
    <transportName>HTTP Listener</transportName>
    <mode>SOURCE</mode>
    <enabled>true</enabled>
    <waitForPrevious>true</waitForPrevious>
  </sourceConnector>
  <destinationConnectors>
    <connector version="4.5.2">
      <metaDataId>1</metaDataId>
      <name>Destination 1</name>
      <properties class="com.mirth.connect.connectors.file.FileDispatcherProperties" version="4.5.2">
        <pluginProperties/>
        <destinationConnectorProperties version="4.5.2">
          <queueEnabled>false</queueEnabled>
          <sendFirst>false</sendFirst>
          <retryIntervalMillis>10000</retryIntervalMillis>
          <regenerateTemplate>false</regenerateTemplate>
          <retryCount>0</retryCount>
          <rotate>false</rotate>
          <includeFilterTransformer>false</includeFilterTransformer>
          <threadCount>1</threadCount>
          <threadAssignmentVariable></threadAssignmentVariable>
          <validateResponse>false</validateResponse>
          <resourceIds class="linked-hash-map">
            <entry>
              <string>Default Resource</string>
              <string>[Default Resource]</string>
            </entry>
          </resourceIds>
          <queueBufferSize>1000</queueBufferSize>
          <reattachAttachments>true</reattachAttachments>
        </destinationConnectorProperties>
        <scheme>FILE</scheme>
        <host>C:/Mirth_Export</host>
        <outputPattern>${date.get(&apos;yyyyMMdd_HHmmss&apos;)}_CheckIn.json</outputPattern>
        <anonymous>true</anonymous>
        <username>anonymous</username>
        <password>anonymous</password>
        <timeout>10000</timeout>
        <keepConnectionOpen>true</keepConnectionOpen>
        <maxIdleTime>5000</maxIdleTime>
        <secure>true</secure>
        <passive>true</passive>
        <validateConnection>true</validateConnection>
        <outputAppend>true</outputAppend>
        <errorOnExists>false</errorOnExists>
        <temporary>false</temporary>
        <binary>false</binary>
        <charsetEncoding>UTF-8</charsetEncoding>
        <template>${message.rawData}</template>
      </properties>
      <transformer version="4.5.2">
        <elements/>
        <inboundDataType>RAW</inboundDataType>
        <outboundDataType>RAW</outboundDataType>
        <inboundProperties class="com.mirth.connect.plugins.datatypes.raw.RawDataTypeProperties" version="4.5.2">
          <batchProperties class="com.mirth.connect.plugins.datatypes.raw.RawBatchProperties" version="4.5.2">
            <splitType>JavaScript</splitType>
            <batchScript></batchScript>
          </batchProperties>
        </inboundProperties>
        <outboundProperties class="com.mirth.connect.plugins.datatypes.raw.RawDataTypeProperties" version="4.5.2">
          <batchProperties class="com.mirth.connect.plugins.datatypes.raw.RawBatchProperties" version="4.5.2">
            <splitType>JavaScript</splitType>
            <batchScript></batchScript>
          </batchProperties>
        </outboundProperties>
      </transformer>
      <responseTransformer version="4.5.2">
        <elements/>
        <inboundDataType>RAW</inboundDataType>
        <outboundDataType>RAW</outboundDataType>
        <inboundProperties class="com.mirth.connect.plugins.datatypes.raw.RawDataTypeProperties" version="4.5.2">
          <batchProperties class="com.mirth.connect.plugins.datatypes.raw.RawBatchProperties" version="4.5.2">
            <splitType>JavaScript</splitType>
            <batchScript></batchScript>
          </batchProperties>
        </inboundProperties>
        <outboundProperties class="com.mirth.connect.plugins.datatypes.raw.RawDataTypeProperties" version="4.5.2">
          <batchProperties class="com.mirth.connect.plugins.datatypes.raw.RawBatchProperties" version="4.5.2">
            <splitType>JavaScript</splitType>
            <batchScript></batchScript>
          </batchProperties>
        </outboundProperties>
      </responseTransformer>
      <filter version="4.5.2">
        <elements/>
      </filter>
      <transportName>File Writer</transportName>
      <mode>DESTINATION</mode>
      <enabled>true</enabled>
      <waitForPrevious>true</waitForPrevious>
    </connector>
  </destinationConnectors>
  <preprocessingScript>// Modify the message variable below to pre process data
return message;</preprocessingScript>
  <postprocessingScript>// This script executes once after a message has been processed
// Responses returned from here will be stored as &quot;Postprocessor&quot; in the response map
return;</postprocessingScript>
  <deployScript>// This script executes once when the channel is deployed
// You only have access to the globalMap and globalChannelMap here to persist data
return;</deployScript>
  <undeployScript>// This script executes once when the channel is undeployed
// You only have access to the globalMap and globalChannelMap here to persist data
return;</undeployScript>
  <properties version="4.5.2">
    <clearGlobalChannelMap>true</clearGlobalChannelMap>
    <messageStorageMode>DEVELOPMENT</messageStorageMode>
    <encryptData>false</encryptData>
    <encryptAttachments>false</encryptAttachments>
    <encryptCustomMetaData>false</encryptCustomMetaData>
    <removeContentOnCompletion>false</removeContentOnCompletion>
    <removeOnlyFilteredOnCompletion>false</removeOnlyFilteredOnCompletion>
    <removeAttachmentsOnCompletion>false</removeAttachmentsOnCompletion>
    <initialState>STARTED</initialState>
    <storeAttachments>true</storeAttachments>
    <metaDataColumns>
      <metaDataColumn>
        <name>SOURCE</name>
        <type>STRING</type>
        <mappingName>mirth_source</mappingName>
      </metaDataColumn>
      <metaDataColumn>
        <name>TYPE</name>
        <type>STRING</type>
        <mappingName>mirth_type</mappingName>
      </metaDataColumn>
    </metaDataColumns>
    <attachmentProperties version="4.5.2">
      <type>None</type>
      <properties/>
    </attachmentProperties>
    <resourceIds class="linked-hash-map">
      <entry>
        <string>Default Resource</string>
        <string>[Default Resource]</string>
      </entry>
    </resourceIds>
  </properties>
</channel>');


--
-- TOC entry 5166 (class 0 OID 16875)
-- Dependencies: 233
-- Data for Name: channel_group; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5163 (class 0 OID 16856)
-- Dependencies: 230
-- Data for Name: code_template; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5162 (class 0 OID 16845)
-- Dependencies: 229
-- Data for Name: code_template_library; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5165 (class 0 OID 16866)
-- Dependencies: 232
-- Data for Name: configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.configuration VALUES ('core', 'stats.enabled', '1');
INSERT INTO public.configuration VALUES ('core', 'server.resetglobalvariables', '1');
INSERT INTO public.configuration VALUES ('core', 'smtp.timeout', '5000');
INSERT INTO public.configuration VALUES ('core', 'smtp.auth', '0');
INSERT INTO public.configuration VALUES ('core', 'smtp.secure', '0');
INSERT INTO public.configuration VALUES ('core', 'server.queuebuffersize', '1000');
INSERT INTO public.configuration VALUES ('core', 'stats.time', '1781119035355');
INSERT INTO public.configuration VALUES ('Data Pruner', 'archiverOptions', '<com.mirth.connect.util.messagewriter.MessageWriterOptions>
  <destinationContent>false</destinationContent>
  <encrypt>false</encrypt>
  <includeAttachments>false</includeAttachments>
  <passwordEnabled>false</passwordEnabled>
</com.mirth.connect.util.messagewriter.MessageWriterOptions>');
INSERT INTO public.configuration VALUES ('Data Pruner', 'includeAttachments', '<boolean>false</boolean>');
INSERT INTO public.configuration VALUES ('Data Pruner', 'pruningBlockSize', '1000');
INSERT INTO public.configuration VALUES ('Data Pruner', 'archiveEnabled', '<boolean>false</boolean>');
INSERT INTO public.configuration VALUES ('Data Pruner', 'archiverBlockSize', '50');
INSERT INTO public.configuration VALUES ('Data Pruner', 'maxEventAge', '');
INSERT INTO public.configuration VALUES ('Data Pruner', 'enabled', 'false');
INSERT INTO public.configuration VALUES ('Data Pruner', 'pollingProperties', '<com.mirth.connect.donkey.model.channel.PollConnectorProperties version="4.5.2">
  <pollingType>INTERVAL</pollingType>
  <pollOnStart>false</pollOnStart>
  <pollingFrequency>3600000</pollingFrequency>
  <pollingHour>0</pollingHour>
  <pollingMinute>0</pollingMinute>
  <cronJobs/>
  <pollConnectorPropertiesAdvanced>
    <weekly>true</weekly>
    <inactiveDays>
      <boolean>false</boolean>
      <boolean>false</boolean>
      <boolean>false</boolean>
      <boolean>false</boolean>
      <boolean>false</boolean>
      <boolean>false</boolean>
      <boolean>false</boolean>
      <boolean>false</boolean>
    </inactiveDays>
    <dayOfMonth>1</dayOfMonth>
    <allDay>true</allDay>
    <startingHour>8</startingHour>
    <startingMinute>0</startingMinute>
    <endingHour>17</endingHour>
    <endingMinute>0</endingMinute>
  </pollConnectorPropertiesAdvanced>
</com.mirth.connect.donkey.model.channel.PollConnectorProperties>');
INSERT INTO public.configuration VALUES ('Data Pruner', 'pruneEvents', 'false');
INSERT INTO public.configuration VALUES ('core', 'channelMetadata', '<map>
  <entry>
    <string>bc082c4b-db17-4e8f-9666-b96a1e9a9822</string>
    <com.mirth.connect.model.ChannelMetadata>
      <enabled>true</enabled>
      <lastModified>
        <time>1781162513512</time>
        <timezone>Europe/Zurich</timezone>
      </lastModified>
      <pruningSettings>
        <archiveEnabled>true</archiveEnabled>
        <pruneErroredMessages>false</pruneErroredMessages>
      </pruningSettings>
      <userId>1</userId>
    </com.mirth.connect.model.ChannelMetadata>
  </entry>
</map>');


--
-- TOC entry 5169 (class 0 OID 16895)
-- Dependencies: 236
-- Data for Name: d_channels; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.d_channels VALUES (1, 'bc082c4b-db17-4e8f-9666-b96a1e9a9822');


--
-- TOC entry 5170 (class 0 OID 16905)
-- Dependencies: 237
-- Data for Name: d_m1; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.d_m1 VALUES (16, 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a', '2026-06-11 09:16:32.81+02', true, NULL, NULL, NULL);
INSERT INTO public.d_m1 VALUES (17, 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a', '2026-06-11 09:26:00.01+02', true, NULL, NULL, NULL);


--
-- TOC entry 5174 (class 0 OID 16970)
-- Dependencies: 241
-- Data for Name: d_ma1; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5172 (class 0 OID 16941)
-- Dependencies: 239
-- Data for Name: d_mc1; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.d_mc1 VALUES (0, 16, 1, '{"resourceType":"Bundle","type":"collection","timestamp":"2026-06-11T07:16:32.781Z","identifier":{"system":"http://example.org/case-number","value":"20260611-00059"},"entry":[{"resource":{"resourceType":"Patient","id":"27b2fd2b-a890-4ff0-89a1-1e6466305130","identifier":[{"system":"http://example.org/identifier/ahv","value":"756.1982.1212.12"}],"name":[{"use":"official","family":"Zbinden","given":["Kurt"]}],"gender":"male","birthDate":"1982-12-12","telecom":[{"system":"phone","use":"mobile","value":"0798526341"}],"address":[{"line":["Hirtenweg 12"],"postalCode":"2626","city":"Aarberg","country":"CH"}]}},{"resource":{"resourceType":"Questionnaire","id":"intake-questionnaire","status":"active","title":"Online Patient Check-in"}},{"resource":{"resourceType":"QuestionnaireResponse","id":"qr-20260611-00059","status":"completed","questionnaire":"Questionnaire/intake-questionnaire","subject":{"reference":"Patient/27b2fd2b-a890-4ff0-89a1-1e6466305130"},"authored":"2026-06-11T07:16:32.781Z","item":[{"linkId":"medical_general","text":"Allgemeine Anamnese (Inkl. Allergien & Familie)","item":[{"linkId":"weight_kg","text":"Gewicht (kg)","answer":[{"valueInteger":86}]},{"linkId":"height_cm","text":"Grösse (cm)","answer":[{"valueInteger":186}]}]},{"linkId":"medical_cardio","text":"Herz-Kreislauf","item":[]},{"linkId":"medical_lung","text":"Lunge","item":[]},{"linkId":"medical_other","text":"Weitere Diagnosen","item":[]}]}},{"resource":{"resourceType":"Medication","id":"medication-1","code":{"coding":[{"system":"urn:oid:2.51.1.1","code":"1650039","display":"Triofan Heuschnupfen Promopaket 03.2026 italienisch"}],"text":"Triofan Heuschnupfen Promopaket 03.2026 italienisch"}}},{"resource":{"resourceType":"Medication","id":"medication-2","code":{"coding":[{"system":"urn:oid:2.51.1.1","code":"1341239","display":"Fexofenadin Sandoz Filmtabl 120 mg"}],"text":"Fexofenadin Sandoz Filmtabl 120 mg"}}},{"resource":{"resourceType":"MedicationStatement","id":"statement-1","status":"active","category":{"coding":[{"system":"http://terminology.hl7.org/CodeSystem/medication-statement-category","code":"patientspecified","display":"Patient Specified"}]},"subject":{"reference":"Patient/27b2fd2b-a890-4ff0-89a1-1e6466305130"},"medicationReference":{"reference":"Medication/medication-1"},"dateAsserted":"2026-06-11T07:16:32.781Z","dosage":[{"text":"Aus Documedis API"}],"note":[{"text":"Kategorie: Akut"}]}},{"resource":{"resourceType":"MedicationStatement","id":"statement-2","status":"active","category":{"coding":[{"system":"http://terminology.hl7.org/CodeSystem/medication-statement-category","code":"patientspecified","display":"Patient Specified"}]},"subject":{"reference":"Patient/27b2fd2b-a890-4ff0-89a1-1e6466305130"},"medicationReference":{"reference":"Medication/medication-2"},"dateAsserted":"2026-06-11T07:16:32.781Z","dosage":[{"text":"Aus Documedis API"}],"note":[{"text":"Kategorie: Akut"}]}}]}', false, 'RAW');
INSERT INTO public.d_mc1 VALUES (0, 16, 15, '<java.util.Collections_-UnmodifiableMap>
  <m>
    <entry>
      <string>headers</string>
      <com.mirth.connect.userutil.MessageHeaders>
        <delegate class="org.apache.commons.collections4.map.CaseInsensitiveMap" serialization="custom">
          <unserializable-parents/>
          <org.apache.commons.collections4.map.CaseInsensitiveMap>
            <default/>
            <float>0.75</float>
            <int>16</int>
            <int>4</int>
            <string>content-length</string>
            <list>
              <string>2911</string>
            </list>
            <string>connection</string>
            <list>
              <string>keep-alive</string>
            </list>
            <string>host</string>
            <list>
              <string>127.0.0.1:8081</string>
            </list>
            <string>content-type</string>
            <list>
              <string>application/json</string>
            </list>
          </org.apache.commons.collections4.map.CaseInsensitiveMap>
        </delegate>
      </com.mirth.connect.userutil.MessageHeaders>
    </entry>
    <entry>
      <string>localPort</string>
      <int>8081</int>
    </entry>
    <entry>
      <string>method</string>
      <string>POST</string>
    </entry>
    <entry>
      <string>query</string>
      <string></string>
    </entry>
    <entry>
      <string>remotePort</string>
      <int>56695</int>
    </entry>
    <entry>
      <string>contextPath</string>
      <string>/fhir-receiver/</string>
    </entry>
    <entry>
      <string>uri</string>
      <string>/fhir-receiver/</string>
    </entry>
    <entry>
      <string>url</string>
      <string>http://127.0.0.1:8081/fhir-receiver/</string>
    </entry>
    <entry>
      <string>protocol</string>
      <string>HTTP/1.1</string>
    </entry>
    <entry>
      <string>localAddress</string>
      <string>127.0.0.1</string>
    </entry>
    <entry>
      <string>parameters</string>
      <com.mirth.connect.userutil.MessageParameters>
        <delegate/>
      </com.mirth.connect.userutil.MessageParameters>
    </entry>
    <entry>
      <string>remoteAddress</string>
      <string>127.0.0.1</string>
    </entry>
    <entry>
      <string>destinationSet</string>
      <linked-hash-set>
        <int>1</int>
      </linked-hash-set>
    </entry>
  </m>
</java.util.Collections_-UnmodifiableMap>', false, NULL);
INSERT INTO public.d_mc1 VALUES (0, 16, 4, '{"resourceType":"Bundle","type":"collection","timestamp":"2026-06-11T07:16:32.781Z","identifier":{"system":"http://example.org/case-number","value":"20260611-00059"},"entry":[{"resource":{"resourceType":"Patient","id":"27b2fd2b-a890-4ff0-89a1-1e6466305130","identifier":[{"system":"http://example.org/identifier/ahv","value":"756.1982.1212.12"}],"name":[{"use":"official","family":"Zbinden","given":["Kurt"]}],"gender":"male","birthDate":"1982-12-12","telecom":[{"system":"phone","use":"mobile","value":"0798526341"}],"address":[{"line":["Hirtenweg 12"],"postalCode":"2626","city":"Aarberg","country":"CH"}]}},{"resource":{"resourceType":"Questionnaire","id":"intake-questionnaire","status":"active","title":"Online Patient Check-in"}},{"resource":{"resourceType":"QuestionnaireResponse","id":"qr-20260611-00059","status":"completed","questionnaire":"Questionnaire/intake-questionnaire","subject":{"reference":"Patient/27b2fd2b-a890-4ff0-89a1-1e6466305130"},"authored":"2026-06-11T07:16:32.781Z","item":[{"linkId":"medical_general","text":"Allgemeine Anamnese (Inkl. Allergien & Familie)","item":[{"linkId":"weight_kg","text":"Gewicht (kg)","answer":[{"valueInteger":86}]},{"linkId":"height_cm","text":"Grösse (cm)","answer":[{"valueInteger":186}]}]},{"linkId":"medical_cardio","text":"Herz-Kreislauf","item":[]},{"linkId":"medical_lung","text":"Lunge","item":[]},{"linkId":"medical_other","text":"Weitere Diagnosen","item":[]}]}},{"resource":{"resourceType":"Medication","id":"medication-1","code":{"coding":[{"system":"urn:oid:2.51.1.1","code":"1650039","display":"Triofan Heuschnupfen Promopaket 03.2026 italienisch"}],"text":"Triofan Heuschnupfen Promopaket 03.2026 italienisch"}}},{"resource":{"resourceType":"Medication","id":"medication-2","code":{"coding":[{"system":"urn:oid:2.51.1.1","code":"1341239","display":"Fexofenadin Sandoz Filmtabl 120 mg"}],"text":"Fexofenadin Sandoz Filmtabl 120 mg"}}},{"resource":{"resourceType":"MedicationStatement","id":"statement-1","status":"active","category":{"coding":[{"system":"http://terminology.hl7.org/CodeSystem/medication-statement-category","code":"patientspecified","display":"Patient Specified"}]},"subject":{"reference":"Patient/27b2fd2b-a890-4ff0-89a1-1e6466305130"},"medicationReference":{"reference":"Medication/medication-1"},"dateAsserted":"2026-06-11T07:16:32.781Z","dosage":[{"text":"Aus Documedis API"}],"note":[{"text":"Kategorie: Akut"}]}},{"resource":{"resourceType":"MedicationStatement","id":"statement-2","status":"active","category":{"coding":[{"system":"http://terminology.hl7.org/CodeSystem/medication-statement-category","code":"patientspecified","display":"Patient Specified"}]},"subject":{"reference":"Patient/27b2fd2b-a890-4ff0-89a1-1e6466305130"},"medicationReference":{"reference":"Medication/medication-2"},"dateAsserted":"2026-06-11T07:16:32.781Z","dosage":[{"text":"Aus Documedis API"}],"note":[{"text":"Kategorie: Akut"}]}}]}', false, 'RAW');
INSERT INTO public.d_mc1 VALUES (1, 16, 4, '{"resourceType":"Bundle","type":"collection","timestamp":"2026-06-11T07:16:32.781Z","identifier":{"system":"http://example.org/case-number","value":"20260611-00059"},"entry":[{"resource":{"resourceType":"Patient","id":"27b2fd2b-a890-4ff0-89a1-1e6466305130","identifier":[{"system":"http://example.org/identifier/ahv","value":"756.1982.1212.12"}],"name":[{"use":"official","family":"Zbinden","given":["Kurt"]}],"gender":"male","birthDate":"1982-12-12","telecom":[{"system":"phone","use":"mobile","value":"0798526341"}],"address":[{"line":["Hirtenweg 12"],"postalCode":"2626","city":"Aarberg","country":"CH"}]}},{"resource":{"resourceType":"Questionnaire","id":"intake-questionnaire","status":"active","title":"Online Patient Check-in"}},{"resource":{"resourceType":"QuestionnaireResponse","id":"qr-20260611-00059","status":"completed","questionnaire":"Questionnaire/intake-questionnaire","subject":{"reference":"Patient/27b2fd2b-a890-4ff0-89a1-1e6466305130"},"authored":"2026-06-11T07:16:32.781Z","item":[{"linkId":"medical_general","text":"Allgemeine Anamnese (Inkl. Allergien & Familie)","item":[{"linkId":"weight_kg","text":"Gewicht (kg)","answer":[{"valueInteger":86}]},{"linkId":"height_cm","text":"Grösse (cm)","answer":[{"valueInteger":186}]}]},{"linkId":"medical_cardio","text":"Herz-Kreislauf","item":[]},{"linkId":"medical_lung","text":"Lunge","item":[]},{"linkId":"medical_other","text":"Weitere Diagnosen","item":[]}]}},{"resource":{"resourceType":"Medication","id":"medication-1","code":{"coding":[{"system":"urn:oid:2.51.1.1","code":"1650039","display":"Triofan Heuschnupfen Promopaket 03.2026 italienisch"}],"text":"Triofan Heuschnupfen Promopaket 03.2026 italienisch"}}},{"resource":{"resourceType":"Medication","id":"medication-2","code":{"coding":[{"system":"urn:oid:2.51.1.1","code":"1341239","display":"Fexofenadin Sandoz Filmtabl 120 mg"}],"text":"Fexofenadin Sandoz Filmtabl 120 mg"}}},{"resource":{"resourceType":"MedicationStatement","id":"statement-1","status":"active","category":{"coding":[{"system":"http://terminology.hl7.org/CodeSystem/medication-statement-category","code":"patientspecified","display":"Patient Specified"}]},"subject":{"reference":"Patient/27b2fd2b-a890-4ff0-89a1-1e6466305130"},"medicationReference":{"reference":"Medication/medication-1"},"dateAsserted":"2026-06-11T07:16:32.781Z","dosage":[{"text":"Aus Documedis API"}],"note":[{"text":"Kategorie: Akut"}]}},{"resource":{"resourceType":"MedicationStatement","id":"statement-2","status":"active","category":{"coding":[{"system":"http://terminology.hl7.org/CodeSystem/medication-statement-category","code":"patientspecified","display":"Patient Specified"}]},"subject":{"reference":"Patient/27b2fd2b-a890-4ff0-89a1-1e6466305130"},"medicationReference":{"reference":"Medication/medication-2"},"dateAsserted":"2026-06-11T07:16:32.781Z","dosage":[{"text":"Aus Documedis API"}],"note":[{"text":"Kategorie: Akut"}]}}]}', false, 'RAW');
INSERT INTO public.d_mc1 VALUES (1, 16, 5, '<com.mirth.connect.connectors.file.FileDispatcherProperties version="4.5.2">
  <pluginProperties/>
  <destinationConnectorProperties version="4.5.2">
    <queueEnabled>false</queueEnabled>
    <sendFirst>false</sendFirst>
    <retryIntervalMillis>10000</retryIntervalMillis>
    <regenerateTemplate>false</regenerateTemplate>
    <retryCount>0</retryCount>
    <rotate>false</rotate>
    <includeFilterTransformer>false</includeFilterTransformer>
    <threadCount>1</threadCount>
    <threadAssignmentVariable></threadAssignmentVariable>
    <validateResponse>false</validateResponse>
    <resourceIds class="linked-hash-map">
      <entry>
        <string>Default Resource</string>
        <string>[Default Resource]</string>
      </entry>
    </resourceIds>
    <queueBufferSize>1000</queueBufferSize>
    <reattachAttachments>true</reattachAttachments>
  </destinationConnectorProperties>
  <scheme>FILE</scheme>
  <host>C:/Mirth_Export</host>
  <outputPattern>20260611_091632_CheckIn.json</outputPattern>
  <anonymous>true</anonymous>
  <username>anonymous</username>
  <password>anonymous</password>
  <timeout>10000</timeout>
  <keepConnectionOpen>true</keepConnectionOpen>
  <maxIdleTime>5000</maxIdleTime>
  <secure>true</secure>
  <passive>true</passive>
  <validateConnection>true</validateConnection>
  <outputAppend>true</outputAppend>
  <errorOnExists>false</errorOnExists>
  <temporary>false</temporary>
  <binary>false</binary>
  <charsetEncoding>DEFAULT_ENCODING</charsetEncoding>
  <template>{&quot;resourceType&quot;:&quot;Bundle&quot;,&quot;type&quot;:&quot;collection&quot;,&quot;timestamp&quot;:&quot;2026-06-11T07:16:32.781Z&quot;,&quot;identifier&quot;:{&quot;system&quot;:&quot;http://example.org/case-number&quot;,&quot;value&quot;:&quot;20260611-00059&quot;},&quot;entry&quot;:[{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;Patient&quot;,&quot;id&quot;:&quot;27b2fd2b-a890-4ff0-89a1-1e6466305130&quot;,&quot;identifier&quot;:[{&quot;system&quot;:&quot;http://example.org/identifier/ahv&quot;,&quot;value&quot;:&quot;756.1982.1212.12&quot;}],&quot;name&quot;:[{&quot;use&quot;:&quot;official&quot;,&quot;family&quot;:&quot;Zbinden&quot;,&quot;given&quot;:[&quot;Kurt&quot;]}],&quot;gender&quot;:&quot;male&quot;,&quot;birthDate&quot;:&quot;1982-12-12&quot;,&quot;telecom&quot;:[{&quot;system&quot;:&quot;phone&quot;,&quot;use&quot;:&quot;mobile&quot;,&quot;value&quot;:&quot;0798526341&quot;}],&quot;address&quot;:[{&quot;line&quot;:[&quot;Hirtenweg 12&quot;],&quot;postalCode&quot;:&quot;2626&quot;,&quot;city&quot;:&quot;Aarberg&quot;,&quot;country&quot;:&quot;CH&quot;}]}},{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;Questionnaire&quot;,&quot;id&quot;:&quot;intake-questionnaire&quot;,&quot;status&quot;:&quot;active&quot;,&quot;title&quot;:&quot;Online Patient Check-in&quot;}},{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;QuestionnaireResponse&quot;,&quot;id&quot;:&quot;qr-20260611-00059&quot;,&quot;status&quot;:&quot;completed&quot;,&quot;questionnaire&quot;:&quot;Questionnaire/intake-questionnaire&quot;,&quot;subject&quot;:{&quot;reference&quot;:&quot;Patient/27b2fd2b-a890-4ff0-89a1-1e6466305130&quot;},&quot;authored&quot;:&quot;2026-06-11T07:16:32.781Z&quot;,&quot;item&quot;:[{&quot;linkId&quot;:&quot;medical_general&quot;,&quot;text&quot;:&quot;Allgemeine Anamnese (Inkl. Allergien &amp; Familie)&quot;,&quot;item&quot;:[{&quot;linkId&quot;:&quot;weight_kg&quot;,&quot;text&quot;:&quot;Gewicht (kg)&quot;,&quot;answer&quot;:[{&quot;valueInteger&quot;:86}]},{&quot;linkId&quot;:&quot;height_cm&quot;,&quot;text&quot;:&quot;Grösse (cm)&quot;,&quot;answer&quot;:[{&quot;valueInteger&quot;:186}]}]},{&quot;linkId&quot;:&quot;medical_cardio&quot;,&quot;text&quot;:&quot;Herz-Kreislauf&quot;,&quot;item&quot;:[]},{&quot;linkId&quot;:&quot;medical_lung&quot;,&quot;text&quot;:&quot;Lunge&quot;,&quot;item&quot;:[]},{&quot;linkId&quot;:&quot;medical_other&quot;,&quot;text&quot;:&quot;Weitere Diagnosen&quot;,&quot;item&quot;:[]}]}},{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;Medication&quot;,&quot;id&quot;:&quot;medication-1&quot;,&quot;code&quot;:{&quot;coding&quot;:[{&quot;system&quot;:&quot;urn:oid:2.51.1.1&quot;,&quot;code&quot;:&quot;1650039&quot;,&quot;display&quot;:&quot;Triofan Heuschnupfen Promopaket 03.2026 italienisch&quot;}],&quot;text&quot;:&quot;Triofan Heuschnupfen Promopaket 03.2026 italienisch&quot;}}},{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;Medication&quot;,&quot;id&quot;:&quot;medication-2&quot;,&quot;code&quot;:{&quot;coding&quot;:[{&quot;system&quot;:&quot;urn:oid:2.51.1.1&quot;,&quot;code&quot;:&quot;1341239&quot;,&quot;display&quot;:&quot;Fexofenadin Sandoz Filmtabl 120 mg&quot;}],&quot;text&quot;:&quot;Fexofenadin Sandoz Filmtabl 120 mg&quot;}}},{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;MedicationStatement&quot;,&quot;id&quot;:&quot;statement-1&quot;,&quot;status&quot;:&quot;active&quot;,&quot;category&quot;:{&quot;coding&quot;:[{&quot;system&quot;:&quot;http://terminology.hl7.org/CodeSystem/medication-statement-category&quot;,&quot;code&quot;:&quot;patientspecified&quot;,&quot;display&quot;:&quot;Patient Specified&quot;}]},&quot;subject&quot;:{&quot;reference&quot;:&quot;Patient/27b2fd2b-a890-4ff0-89a1-1e6466305130&quot;},&quot;medicationReference&quot;:{&quot;reference&quot;:&quot;Medication/medication-1&quot;},&quot;dateAsserted&quot;:&quot;2026-06-11T07:16:32.781Z&quot;,&quot;dosage&quot;:[{&quot;text&quot;:&quot;Aus Documedis API&quot;}],&quot;note&quot;:[{&quot;text&quot;:&quot;Kategorie: Akut&quot;}]}},{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;MedicationStatement&quot;,&quot;id&quot;:&quot;statement-2&quot;,&quot;status&quot;:&quot;active&quot;,&quot;category&quot;:{&quot;coding&quot;:[{&quot;system&quot;:&quot;http://terminology.hl7.org/CodeSystem/medication-statement-category&quot;,&quot;code&quot;:&quot;patientspecified&quot;,&quot;display&quot;:&quot;Patient Specified&quot;}]},&quot;subject&quot;:{&quot;reference&quot;:&quot;Patient/27b2fd2b-a890-4ff0-89a1-1e6466305130&quot;},&quot;medicationReference&quot;:{&quot;reference&quot;:&quot;Medication/medication-2&quot;},&quot;dateAsserted&quot;:&quot;2026-06-11T07:16:32.781Z&quot;,&quot;dosage&quot;:[{&quot;text&quot;:&quot;Aus Documedis API&quot;}],&quot;note&quot;:[{&quot;text&quot;:&quot;Kategorie: Akut&quot;}]}}]}</template>
</com.mirth.connect.connectors.file.FileDispatcherProperties>', false, NULL);
INSERT INTO public.d_mc1 VALUES (1, 16, 6, '<response>
  <status>SENT</status>
  <message></message>
  <statusMessage>File successfully written: C:/Mirth_Export/20260611_091632_CheckIn.json</statusMessage>
</response>', false, 'RAW');
INSERT INTO public.d_mc1 VALUES (1, 16, 11, '<map>
  <entry>
    <string>d1</string>
    <response>
      <status>SENT</status>
      <message></message>
      <statusMessage>File successfully written: C:/Mirth_Export/20260611_091632_CheckIn.json</statusMessage>
    </response>
  </entry>
</map>', false, NULL);
INSERT INTO public.d_mc1 VALUES (0, 16, 11, '<map>
  <entry>
    <string>d1</string>
    <response>
      <status>SENT</status>
      <message></message>
      <statusMessage>File successfully written: C:/Mirth_Export/20260611_091632_CheckIn.json</statusMessage>
    </response>
  </entry>
</map>', false, NULL);
INSERT INTO public.d_mc1 VALUES (0, 17, 15, '<java.util.Collections_-UnmodifiableMap>
  <m>
    <entry>
      <string>headers</string>
      <com.mirth.connect.userutil.MessageHeaders>
        <delegate class="org.apache.commons.collections4.map.CaseInsensitiveMap" serialization="custom">
          <unserializable-parents/>
          <org.apache.commons.collections4.map.CaseInsensitiveMap>
            <default/>
            <float>0.75</float>
            <int>16</int>
            <int>4</int>
            <string>content-length</string>
            <list>
              <string>3980</string>
            </list>
            <string>connection</string>
            <list>
              <string>keep-alive</string>
            </list>
            <string>host</string>
            <list>
              <string>127.0.0.1:8081</string>
            </list>
            <string>content-type</string>
            <list>
              <string>application/json</string>
            </list>
          </org.apache.commons.collections4.map.CaseInsensitiveMap>
        </delegate>
      </com.mirth.connect.userutil.MessageHeaders>
    </entry>
    <entry>
      <string>localPort</string>
      <int>8081</int>
    </entry>
    <entry>
      <string>method</string>
      <string>POST</string>
    </entry>
    <entry>
      <string>query</string>
      <string></string>
    </entry>
    <entry>
      <string>remotePort</string>
      <int>62789</int>
    </entry>
    <entry>
      <string>contextPath</string>
      <string>/fhir-receiver/</string>
    </entry>
    <entry>
      <string>uri</string>
      <string>/fhir-receiver/</string>
    </entry>
    <entry>
      <string>url</string>
      <string>http://127.0.0.1:8081/fhir-receiver/</string>
    </entry>
    <entry>
      <string>protocol</string>
      <string>HTTP/1.1</string>
    </entry>
    <entry>
      <string>localAddress</string>
      <string>127.0.0.1</string>
    </entry>
    <entry>
      <string>parameters</string>
      <com.mirth.connect.userutil.MessageParameters>
        <delegate/>
      </com.mirth.connect.userutil.MessageParameters>
    </entry>
    <entry>
      <string>remoteAddress</string>
      <string>127.0.0.1</string>
    </entry>
    <entry>
      <string>destinationSet</string>
      <linked-hash-set>
        <int>1</int>
      </linked-hash-set>
    </entry>
  </m>
</java.util.Collections_-UnmodifiableMap>', false, NULL);
INSERT INTO public.d_mc1 VALUES (0, 17, 1, '{"resourceType":"Bundle","type":"collection","timestamp":"2026-06-11T07:26:00.006Z","identifier":{"system":"http://example.org/case-number","value":"20260611-00060"},"entry":[{"resource":{"resourceType":"Patient","id":"491d45d9-c3dc-4217-bccd-818c807eca6b","identifier":[{"system":"http://example.org/identifier/ahv","value":"756.1988.3108.31"}],"name":[{"use":"official","family":"Yuki","given":["Jaden"]}],"gender":"male","birthDate":"1988-08-31","telecom":[{"system":"phone","use":"mobile","value":"0798883108"},{"system":"email","value":"jayuki@gmail.com"}],"address":[{"line":["Akademiestrasse 31"],"postalCode":"8031","city":"Domino City","country":"CH"}]}},{"resource":{"resourceType":"RelatedPerson","id":"c25f0487-ac1a-4f4f-bbf5-d4d51a2c5e7c","patient":{"reference":"Patient/491d45d9-c3dc-4217-bccd-818c807eca6b"},"name":[{"use":"official","family":"Rhodes","given":["Alexis"]}],"telecom":[{"system":"phone","value":"0761002585"}],"address":[{"line":["Akademiestrasse 31"],"country":"CH"}]}},{"resource":{"resourceType":"Questionnaire","id":"intake-questionnaire","status":"active","title":"Online Patient Check-in"}},{"resource":{"resourceType":"QuestionnaireResponse","id":"qr-20260611-00060","status":"completed","questionnaire":"Questionnaire/intake-questionnaire","subject":{"reference":"Patient/491d45d9-c3dc-4217-bccd-818c807eca6b"},"authored":"2026-06-11T07:26:00.006Z","item":[{"linkId":"medical_general","text":"Allgemeine Anamnese (Inkl. Allergien & Familie)","item":[{"linkId":"allergies","text":"Allergien vorhanden","answer":[{"valueBoolean":false}]},{"linkId":"family_anesthesia_problems","text":"Anästhesieprobleme in der Familie","answer":[{"valueBoolean":false}]},{"linkId":"weight_kg","text":"Gewicht (kg)","answer":[{"valueInteger":60}]},{"linkId":"height_cm","text":"Grösse (cm)","answer":[{"valueInteger":166}]}]},{"linkId":"medical_cardio","text":"Herz-Kreislauf","item":[{"linkId":"blood_pressure","text":"Blutdruckprobleme","answer":[{"valueBoolean":true}]},{"linkId":"thrombosis","text":"Thrombose/Embolie","answer":[{"valueBoolean":false}]}]},{"linkId":"medical_lung","text":"Lunge","item":[{"linkId":"smoker","text":"Raucher/in","answer":[{"valueBoolean":false}]},{"linkId":"asthma","text":"Asthma","answer":[{"valueBoolean":false}]}]},{"linkId":"medical_other","text":"Weitere Diagnosen","item":[{"linkId":"diabetes","text":"Diabetes","answer":[{"valueBoolean":false}]},{"linkId":"cancer","text":"Tumorerkrankung","answer":[{"valueBoolean":false}]}]}]}},{"resource":{"resourceType":"Medication","id":"medication-1","code":{"coding":[{"system":"urn:oid:2.51.1.1","code":"1635692","display":"Vitamin C PANPHARMA (IMP D) Inj Lös 500 mg/5ml"}],"text":"Vitamin C PANPHARMA (IMP D) Inj Lös 500 mg/5ml"}}},{"resource":{"resourceType":"Medication","id":"medication-2","code":{"coding":[{"system":"urn:oid:2.51.1.1","code":"1306405","display":"Magnesium Axapharm Brausetabl 375 mg"}],"text":"Magnesium Axapharm Brausetabl 375 mg"}}},{"resource":{"resourceType":"MedicationStatement","id":"statement-1","status":"active","category":{"coding":[{"system":"http://terminology.hl7.org/CodeSystem/medication-statement-category","code":"patientspecified","display":"Patient Specified"}]},"subject":{"reference":"Patient/491d45d9-c3dc-4217-bccd-818c807eca6b"},"medicationReference":{"reference":"Medication/medication-1"},"dateAsserted":"2026-06-11T07:26:00.006Z","dosage":[{"text":"Aus Documedis API"}],"note":[{"text":"Kategorie: Dauermedikation"}]}},{"resource":{"resourceType":"MedicationStatement","id":"statement-2","status":"active","category":{"coding":[{"system":"http://terminology.hl7.org/CodeSystem/medication-statement-category","code":"patientspecified","display":"Patient Specified"}]},"subject":{"reference":"Patient/491d45d9-c3dc-4217-bccd-818c807eca6b"},"medicationReference":{"reference":"Medication/medication-2"},"dateAsserted":"2026-06-11T07:26:00.006Z","dosage":[{"text":"Aus Documedis API"}],"note":[{"text":"Kategorie: Akut"}]}}]}', false, 'RAW');
INSERT INTO public.d_mc1 VALUES (0, 17, 4, '{"resourceType":"Bundle","type":"collection","timestamp":"2026-06-11T07:26:00.006Z","identifier":{"system":"http://example.org/case-number","value":"20260611-00060"},"entry":[{"resource":{"resourceType":"Patient","id":"491d45d9-c3dc-4217-bccd-818c807eca6b","identifier":[{"system":"http://example.org/identifier/ahv","value":"756.1988.3108.31"}],"name":[{"use":"official","family":"Yuki","given":["Jaden"]}],"gender":"male","birthDate":"1988-08-31","telecom":[{"system":"phone","use":"mobile","value":"0798883108"},{"system":"email","value":"jayuki@gmail.com"}],"address":[{"line":["Akademiestrasse 31"],"postalCode":"8031","city":"Domino City","country":"CH"}]}},{"resource":{"resourceType":"RelatedPerson","id":"c25f0487-ac1a-4f4f-bbf5-d4d51a2c5e7c","patient":{"reference":"Patient/491d45d9-c3dc-4217-bccd-818c807eca6b"},"name":[{"use":"official","family":"Rhodes","given":["Alexis"]}],"telecom":[{"system":"phone","value":"0761002585"}],"address":[{"line":["Akademiestrasse 31"],"country":"CH"}]}},{"resource":{"resourceType":"Questionnaire","id":"intake-questionnaire","status":"active","title":"Online Patient Check-in"}},{"resource":{"resourceType":"QuestionnaireResponse","id":"qr-20260611-00060","status":"completed","questionnaire":"Questionnaire/intake-questionnaire","subject":{"reference":"Patient/491d45d9-c3dc-4217-bccd-818c807eca6b"},"authored":"2026-06-11T07:26:00.006Z","item":[{"linkId":"medical_general","text":"Allgemeine Anamnese (Inkl. Allergien & Familie)","item":[{"linkId":"allergies","text":"Allergien vorhanden","answer":[{"valueBoolean":false}]},{"linkId":"family_anesthesia_problems","text":"Anästhesieprobleme in der Familie","answer":[{"valueBoolean":false}]},{"linkId":"weight_kg","text":"Gewicht (kg)","answer":[{"valueInteger":60}]},{"linkId":"height_cm","text":"Grösse (cm)","answer":[{"valueInteger":166}]}]},{"linkId":"medical_cardio","text":"Herz-Kreislauf","item":[{"linkId":"blood_pressure","text":"Blutdruckprobleme","answer":[{"valueBoolean":true}]},{"linkId":"thrombosis","text":"Thrombose/Embolie","answer":[{"valueBoolean":false}]}]},{"linkId":"medical_lung","text":"Lunge","item":[{"linkId":"smoker","text":"Raucher/in","answer":[{"valueBoolean":false}]},{"linkId":"asthma","text":"Asthma","answer":[{"valueBoolean":false}]}]},{"linkId":"medical_other","text":"Weitere Diagnosen","item":[{"linkId":"diabetes","text":"Diabetes","answer":[{"valueBoolean":false}]},{"linkId":"cancer","text":"Tumorerkrankung","answer":[{"valueBoolean":false}]}]}]}},{"resource":{"resourceType":"Medication","id":"medication-1","code":{"coding":[{"system":"urn:oid:2.51.1.1","code":"1635692","display":"Vitamin C PANPHARMA (IMP D) Inj Lös 500 mg/5ml"}],"text":"Vitamin C PANPHARMA (IMP D) Inj Lös 500 mg/5ml"}}},{"resource":{"resourceType":"Medication","id":"medication-2","code":{"coding":[{"system":"urn:oid:2.51.1.1","code":"1306405","display":"Magnesium Axapharm Brausetabl 375 mg"}],"text":"Magnesium Axapharm Brausetabl 375 mg"}}},{"resource":{"resourceType":"MedicationStatement","id":"statement-1","status":"active","category":{"coding":[{"system":"http://terminology.hl7.org/CodeSystem/medication-statement-category","code":"patientspecified","display":"Patient Specified"}]},"subject":{"reference":"Patient/491d45d9-c3dc-4217-bccd-818c807eca6b"},"medicationReference":{"reference":"Medication/medication-1"},"dateAsserted":"2026-06-11T07:26:00.006Z","dosage":[{"text":"Aus Documedis API"}],"note":[{"text":"Kategorie: Dauermedikation"}]}},{"resource":{"resourceType":"MedicationStatement","id":"statement-2","status":"active","category":{"coding":[{"system":"http://terminology.hl7.org/CodeSystem/medication-statement-category","code":"patientspecified","display":"Patient Specified"}]},"subject":{"reference":"Patient/491d45d9-c3dc-4217-bccd-818c807eca6b"},"medicationReference":{"reference":"Medication/medication-2"},"dateAsserted":"2026-06-11T07:26:00.006Z","dosage":[{"text":"Aus Documedis API"}],"note":[{"text":"Kategorie: Akut"}]}}]}', false, 'RAW');
INSERT INTO public.d_mc1 VALUES (1, 17, 4, '{"resourceType":"Bundle","type":"collection","timestamp":"2026-06-11T07:26:00.006Z","identifier":{"system":"http://example.org/case-number","value":"20260611-00060"},"entry":[{"resource":{"resourceType":"Patient","id":"491d45d9-c3dc-4217-bccd-818c807eca6b","identifier":[{"system":"http://example.org/identifier/ahv","value":"756.1988.3108.31"}],"name":[{"use":"official","family":"Yuki","given":["Jaden"]}],"gender":"male","birthDate":"1988-08-31","telecom":[{"system":"phone","use":"mobile","value":"0798883108"},{"system":"email","value":"jayuki@gmail.com"}],"address":[{"line":["Akademiestrasse 31"],"postalCode":"8031","city":"Domino City","country":"CH"}]}},{"resource":{"resourceType":"RelatedPerson","id":"c25f0487-ac1a-4f4f-bbf5-d4d51a2c5e7c","patient":{"reference":"Patient/491d45d9-c3dc-4217-bccd-818c807eca6b"},"name":[{"use":"official","family":"Rhodes","given":["Alexis"]}],"telecom":[{"system":"phone","value":"0761002585"}],"address":[{"line":["Akademiestrasse 31"],"country":"CH"}]}},{"resource":{"resourceType":"Questionnaire","id":"intake-questionnaire","status":"active","title":"Online Patient Check-in"}},{"resource":{"resourceType":"QuestionnaireResponse","id":"qr-20260611-00060","status":"completed","questionnaire":"Questionnaire/intake-questionnaire","subject":{"reference":"Patient/491d45d9-c3dc-4217-bccd-818c807eca6b"},"authored":"2026-06-11T07:26:00.006Z","item":[{"linkId":"medical_general","text":"Allgemeine Anamnese (Inkl. Allergien & Familie)","item":[{"linkId":"allergies","text":"Allergien vorhanden","answer":[{"valueBoolean":false}]},{"linkId":"family_anesthesia_problems","text":"Anästhesieprobleme in der Familie","answer":[{"valueBoolean":false}]},{"linkId":"weight_kg","text":"Gewicht (kg)","answer":[{"valueInteger":60}]},{"linkId":"height_cm","text":"Grösse (cm)","answer":[{"valueInteger":166}]}]},{"linkId":"medical_cardio","text":"Herz-Kreislauf","item":[{"linkId":"blood_pressure","text":"Blutdruckprobleme","answer":[{"valueBoolean":true}]},{"linkId":"thrombosis","text":"Thrombose/Embolie","answer":[{"valueBoolean":false}]}]},{"linkId":"medical_lung","text":"Lunge","item":[{"linkId":"smoker","text":"Raucher/in","answer":[{"valueBoolean":false}]},{"linkId":"asthma","text":"Asthma","answer":[{"valueBoolean":false}]}]},{"linkId":"medical_other","text":"Weitere Diagnosen","item":[{"linkId":"diabetes","text":"Diabetes","answer":[{"valueBoolean":false}]},{"linkId":"cancer","text":"Tumorerkrankung","answer":[{"valueBoolean":false}]}]}]}},{"resource":{"resourceType":"Medication","id":"medication-1","code":{"coding":[{"system":"urn:oid:2.51.1.1","code":"1635692","display":"Vitamin C PANPHARMA (IMP D) Inj Lös 500 mg/5ml"}],"text":"Vitamin C PANPHARMA (IMP D) Inj Lös 500 mg/5ml"}}},{"resource":{"resourceType":"Medication","id":"medication-2","code":{"coding":[{"system":"urn:oid:2.51.1.1","code":"1306405","display":"Magnesium Axapharm Brausetabl 375 mg"}],"text":"Magnesium Axapharm Brausetabl 375 mg"}}},{"resource":{"resourceType":"MedicationStatement","id":"statement-1","status":"active","category":{"coding":[{"system":"http://terminology.hl7.org/CodeSystem/medication-statement-category","code":"patientspecified","display":"Patient Specified"}]},"subject":{"reference":"Patient/491d45d9-c3dc-4217-bccd-818c807eca6b"},"medicationReference":{"reference":"Medication/medication-1"},"dateAsserted":"2026-06-11T07:26:00.006Z","dosage":[{"text":"Aus Documedis API"}],"note":[{"text":"Kategorie: Dauermedikation"}]}},{"resource":{"resourceType":"MedicationStatement","id":"statement-2","status":"active","category":{"coding":[{"system":"http://terminology.hl7.org/CodeSystem/medication-statement-category","code":"patientspecified","display":"Patient Specified"}]},"subject":{"reference":"Patient/491d45d9-c3dc-4217-bccd-818c807eca6b"},"medicationReference":{"reference":"Medication/medication-2"},"dateAsserted":"2026-06-11T07:26:00.006Z","dosage":[{"text":"Aus Documedis API"}],"note":[{"text":"Kategorie: Akut"}]}}]}', false, 'RAW');
INSERT INTO public.d_mc1 VALUES (1, 17, 5, '<com.mirth.connect.connectors.file.FileDispatcherProperties version="4.5.2">
  <pluginProperties/>
  <destinationConnectorProperties version="4.5.2">
    <queueEnabled>false</queueEnabled>
    <sendFirst>false</sendFirst>
    <retryIntervalMillis>10000</retryIntervalMillis>
    <regenerateTemplate>false</regenerateTemplate>
    <retryCount>0</retryCount>
    <rotate>false</rotate>
    <includeFilterTransformer>false</includeFilterTransformer>
    <threadCount>1</threadCount>
    <threadAssignmentVariable></threadAssignmentVariable>
    <validateResponse>false</validateResponse>
    <resourceIds class="linked-hash-map">
      <entry>
        <string>Default Resource</string>
        <string>[Default Resource]</string>
      </entry>
    </resourceIds>
    <queueBufferSize>1000</queueBufferSize>
    <reattachAttachments>true</reattachAttachments>
  </destinationConnectorProperties>
  <scheme>FILE</scheme>
  <host>C:/Mirth_Export</host>
  <outputPattern>20260611_092600_CheckIn.json</outputPattern>
  <anonymous>true</anonymous>
  <username>anonymous</username>
  <password>anonymous</password>
  <timeout>10000</timeout>
  <keepConnectionOpen>true</keepConnectionOpen>
  <maxIdleTime>5000</maxIdleTime>
  <secure>true</secure>
  <passive>true</passive>
  <validateConnection>true</validateConnection>
  <outputAppend>true</outputAppend>
  <errorOnExists>false</errorOnExists>
  <temporary>false</temporary>
  <binary>false</binary>
  <charsetEncoding>UTF-8</charsetEncoding>
  <template>{&quot;resourceType&quot;:&quot;Bundle&quot;,&quot;type&quot;:&quot;collection&quot;,&quot;timestamp&quot;:&quot;2026-06-11T07:26:00.006Z&quot;,&quot;identifier&quot;:{&quot;system&quot;:&quot;http://example.org/case-number&quot;,&quot;value&quot;:&quot;20260611-00060&quot;},&quot;entry&quot;:[{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;Patient&quot;,&quot;id&quot;:&quot;491d45d9-c3dc-4217-bccd-818c807eca6b&quot;,&quot;identifier&quot;:[{&quot;system&quot;:&quot;http://example.org/identifier/ahv&quot;,&quot;value&quot;:&quot;756.1988.3108.31&quot;}],&quot;name&quot;:[{&quot;use&quot;:&quot;official&quot;,&quot;family&quot;:&quot;Yuki&quot;,&quot;given&quot;:[&quot;Jaden&quot;]}],&quot;gender&quot;:&quot;male&quot;,&quot;birthDate&quot;:&quot;1988-08-31&quot;,&quot;telecom&quot;:[{&quot;system&quot;:&quot;phone&quot;,&quot;use&quot;:&quot;mobile&quot;,&quot;value&quot;:&quot;0798883108&quot;},{&quot;system&quot;:&quot;email&quot;,&quot;value&quot;:&quot;jayuki@gmail.com&quot;}],&quot;address&quot;:[{&quot;line&quot;:[&quot;Akademiestrasse 31&quot;],&quot;postalCode&quot;:&quot;8031&quot;,&quot;city&quot;:&quot;Domino City&quot;,&quot;country&quot;:&quot;CH&quot;}]}},{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;RelatedPerson&quot;,&quot;id&quot;:&quot;c25f0487-ac1a-4f4f-bbf5-d4d51a2c5e7c&quot;,&quot;patient&quot;:{&quot;reference&quot;:&quot;Patient/491d45d9-c3dc-4217-bccd-818c807eca6b&quot;},&quot;name&quot;:[{&quot;use&quot;:&quot;official&quot;,&quot;family&quot;:&quot;Rhodes&quot;,&quot;given&quot;:[&quot;Alexis&quot;]}],&quot;telecom&quot;:[{&quot;system&quot;:&quot;phone&quot;,&quot;value&quot;:&quot;0761002585&quot;}],&quot;address&quot;:[{&quot;line&quot;:[&quot;Akademiestrasse 31&quot;],&quot;country&quot;:&quot;CH&quot;}]}},{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;Questionnaire&quot;,&quot;id&quot;:&quot;intake-questionnaire&quot;,&quot;status&quot;:&quot;active&quot;,&quot;title&quot;:&quot;Online Patient Check-in&quot;}},{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;QuestionnaireResponse&quot;,&quot;id&quot;:&quot;qr-20260611-00060&quot;,&quot;status&quot;:&quot;completed&quot;,&quot;questionnaire&quot;:&quot;Questionnaire/intake-questionnaire&quot;,&quot;subject&quot;:{&quot;reference&quot;:&quot;Patient/491d45d9-c3dc-4217-bccd-818c807eca6b&quot;},&quot;authored&quot;:&quot;2026-06-11T07:26:00.006Z&quot;,&quot;item&quot;:[{&quot;linkId&quot;:&quot;medical_general&quot;,&quot;text&quot;:&quot;Allgemeine Anamnese (Inkl. Allergien &amp; Familie)&quot;,&quot;item&quot;:[{&quot;linkId&quot;:&quot;allergies&quot;,&quot;text&quot;:&quot;Allergien vorhanden&quot;,&quot;answer&quot;:[{&quot;valueBoolean&quot;:false}]},{&quot;linkId&quot;:&quot;family_anesthesia_problems&quot;,&quot;text&quot;:&quot;Anästhesieprobleme in der Familie&quot;,&quot;answer&quot;:[{&quot;valueBoolean&quot;:false}]},{&quot;linkId&quot;:&quot;weight_kg&quot;,&quot;text&quot;:&quot;Gewicht (kg)&quot;,&quot;answer&quot;:[{&quot;valueInteger&quot;:60}]},{&quot;linkId&quot;:&quot;height_cm&quot;,&quot;text&quot;:&quot;Grösse (cm)&quot;,&quot;answer&quot;:[{&quot;valueInteger&quot;:166}]}]},{&quot;linkId&quot;:&quot;medical_cardio&quot;,&quot;text&quot;:&quot;Herz-Kreislauf&quot;,&quot;item&quot;:[{&quot;linkId&quot;:&quot;blood_pressure&quot;,&quot;text&quot;:&quot;Blutdruckprobleme&quot;,&quot;answer&quot;:[{&quot;valueBoolean&quot;:true}]},{&quot;linkId&quot;:&quot;thrombosis&quot;,&quot;text&quot;:&quot;Thrombose/Embolie&quot;,&quot;answer&quot;:[{&quot;valueBoolean&quot;:false}]}]},{&quot;linkId&quot;:&quot;medical_lung&quot;,&quot;text&quot;:&quot;Lunge&quot;,&quot;item&quot;:[{&quot;linkId&quot;:&quot;smoker&quot;,&quot;text&quot;:&quot;Raucher/in&quot;,&quot;answer&quot;:[{&quot;valueBoolean&quot;:false}]},{&quot;linkId&quot;:&quot;asthma&quot;,&quot;text&quot;:&quot;Asthma&quot;,&quot;answer&quot;:[{&quot;valueBoolean&quot;:false}]}]},{&quot;linkId&quot;:&quot;medical_other&quot;,&quot;text&quot;:&quot;Weitere Diagnosen&quot;,&quot;item&quot;:[{&quot;linkId&quot;:&quot;diabetes&quot;,&quot;text&quot;:&quot;Diabetes&quot;,&quot;answer&quot;:[{&quot;valueBoolean&quot;:false}]},{&quot;linkId&quot;:&quot;cancer&quot;,&quot;text&quot;:&quot;Tumorerkrankung&quot;,&quot;answer&quot;:[{&quot;valueBoolean&quot;:false}]}]}]}},{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;Medication&quot;,&quot;id&quot;:&quot;medication-1&quot;,&quot;code&quot;:{&quot;coding&quot;:[{&quot;system&quot;:&quot;urn:oid:2.51.1.1&quot;,&quot;code&quot;:&quot;1635692&quot;,&quot;display&quot;:&quot;Vitamin C PANPHARMA (IMP D) Inj Lös 500 mg/5ml&quot;}],&quot;text&quot;:&quot;Vitamin C PANPHARMA (IMP D) Inj Lös 500 mg/5ml&quot;}}},{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;Medication&quot;,&quot;id&quot;:&quot;medication-2&quot;,&quot;code&quot;:{&quot;coding&quot;:[{&quot;system&quot;:&quot;urn:oid:2.51.1.1&quot;,&quot;code&quot;:&quot;1306405&quot;,&quot;display&quot;:&quot;Magnesium Axapharm Brausetabl 375 mg&quot;}],&quot;text&quot;:&quot;Magnesium Axapharm Brausetabl 375 mg&quot;}}},{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;MedicationStatement&quot;,&quot;id&quot;:&quot;statement-1&quot;,&quot;status&quot;:&quot;active&quot;,&quot;category&quot;:{&quot;coding&quot;:[{&quot;system&quot;:&quot;http://terminology.hl7.org/CodeSystem/medication-statement-category&quot;,&quot;code&quot;:&quot;patientspecified&quot;,&quot;display&quot;:&quot;Patient Specified&quot;}]},&quot;subject&quot;:{&quot;reference&quot;:&quot;Patient/491d45d9-c3dc-4217-bccd-818c807eca6b&quot;},&quot;medicationReference&quot;:{&quot;reference&quot;:&quot;Medication/medication-1&quot;},&quot;dateAsserted&quot;:&quot;2026-06-11T07:26:00.006Z&quot;,&quot;dosage&quot;:[{&quot;text&quot;:&quot;Aus Documedis API&quot;}],&quot;note&quot;:[{&quot;text&quot;:&quot;Kategorie: Dauermedikation&quot;}]}},{&quot;resource&quot;:{&quot;resourceType&quot;:&quot;MedicationStatement&quot;,&quot;id&quot;:&quot;statement-2&quot;,&quot;status&quot;:&quot;active&quot;,&quot;category&quot;:{&quot;coding&quot;:[{&quot;system&quot;:&quot;http://terminology.hl7.org/CodeSystem/medication-statement-category&quot;,&quot;code&quot;:&quot;patientspecified&quot;,&quot;display&quot;:&quot;Patient Specified&quot;}]},&quot;subject&quot;:{&quot;reference&quot;:&quot;Patient/491d45d9-c3dc-4217-bccd-818c807eca6b&quot;},&quot;medicationReference&quot;:{&quot;reference&quot;:&quot;Medication/medication-2&quot;},&quot;dateAsserted&quot;:&quot;2026-06-11T07:26:00.006Z&quot;,&quot;dosage&quot;:[{&quot;text&quot;:&quot;Aus Documedis API&quot;}],&quot;note&quot;:[{&quot;text&quot;:&quot;Kategorie: Akut&quot;}]}}]}</template>
</com.mirth.connect.connectors.file.FileDispatcherProperties>', false, NULL);
INSERT INTO public.d_mc1 VALUES (1, 17, 6, '<response>
  <status>SENT</status>
  <message></message>
  <statusMessage>File successfully written: C:/Mirth_Export/20260611_092600_CheckIn.json</statusMessage>
</response>', false, 'RAW');
INSERT INTO public.d_mc1 VALUES (1, 17, 11, '<map>
  <entry>
    <string>d1</string>
    <response>
      <status>SENT</status>
      <message></message>
      <statusMessage>File successfully written: C:/Mirth_Export/20260611_092600_CheckIn.json</statusMessage>
    </response>
  </entry>
</map>', false, NULL);
INSERT INTO public.d_mc1 VALUES (0, 17, 11, '<map>
  <entry>
    <string>d1</string>
    <response>
      <status>SENT</status>
      <message></message>
      <statusMessage>File successfully written: C:/Mirth_Export/20260611_092600_CheckIn.json</statusMessage>
    </response>
  </entry>
</map>', false, NULL);


--
-- TOC entry 5173 (class 0 OID 16958)
-- Dependencies: 240
-- Data for Name: d_mcm1; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5171 (class 0 OID 16915)
-- Dependencies: 238
-- Data for Name: d_mm1; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.d_mm1 VALUES (0, 16, 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a', '2026-06-11 09:16:32.81+02', 'T', 'Source', 0, NULL, NULL, 0, 0, 0);
INSERT INTO public.d_mm1 VALUES (1, 16, 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a', '2026-06-11 09:16:32.816+02', 'S', 'Destination 1', 1, '2026-06-11 09:16:32.818+02', '2026-06-11 09:16:32.819+02', 0, 1, 1);
INSERT INTO public.d_mm1 VALUES (0, 17, 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a', '2026-06-11 09:26:00.01+02', 'T', 'Source', 0, NULL, NULL, 0, 0, 0);
INSERT INTO public.d_mm1 VALUES (1, 17, 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a', '2026-06-11 09:26:00.012+02', 'S', 'Destination 1', 1, '2026-06-11 09:26:00.015+02', '2026-06-11 09:26:00.016+02', 0, 1, 1);


--
-- TOC entry 5175 (class 0 OID 16986)
-- Dependencies: 242
-- Data for Name: d_ms1; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.d_ms1 VALUES (NULL, 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a', 2, 17, 0, 0, 2, 13, 0, 4);
INSERT INTO public.d_ms1 VALUES (0, 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a', 2, 17, 0, 0, 0, 0, 0, 0);
INSERT INTO public.d_ms1 VALUES (1, 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a', 2, 17, 0, 0, 2, 13, 0, 4);


--
-- TOC entry 5168 (class 0 OID 16887)
-- Dependencies: 235
-- Data for Name: debugger_usage; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5154 (class 0 OID 16765)
-- Dependencies: 221
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.event VALUES (1, '2026-06-10 21:17:11.092+02', 'Server startup', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 0, NULL, 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (2, '2026-06-10 21:17:14.258+02', 'Server startup complete', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 0, NULL, 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (3, '2026-06-10 21:18:39.559+02', 'Login', 'INFORMATION', 'SUCCESS', '<map>
  <entry>
    <string>username</string>
    <string>admin</string>
  </entry>
</map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (4, '2026-06-10 21:18:42.889+02', 'Get resources', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (5, '2026-06-10 21:18:42.927+02', 'Get libraries invoked through Directory Resource', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>resourceId</string>
    <string>Default Resource
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (6, '2026-06-10 21:21:33.921+02', 'Update a user''s password', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>userId</string>
    <string>1
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (7, '2026-06-10 21:21:34.201+02', 'Update user', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>userId</string>
    <string>1
</string>
  </entry>
  <entry>
    <string>user</string>
    <string>User[id=1,username=admin]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (8, '2026-06-10 21:21:34.217+02', 'Set user preference', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>name</string>
    <string>firstlogin
</string>
  </entry>
  <entry>
    <string>userId</string>
    <string>1
</string>
  </entry>
  <entry>
    <string>value</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (9, '2026-06-10 21:21:38.812+02', 'Set user preferences', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>userId</string>
    <string>1
</string>
  </entry>
  <entry>
    <string>properties</string>
    <string>{showNotificationPopup=true, checkForNotifications=true}
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (10, '2026-06-10 21:23:07.337+02', 'Set user preferences', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>userId</string>
    <string>1
</string>
  </entry>
  <entry>
    <string>properties</string>
    <string>{initialTagsChannels=, initialTagsDashboard=}
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (11, '2026-06-10 21:23:07.343+02', 'Logout', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (12, '2026-06-11 00:17:09.573+02', 'Server shutdown', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 0, NULL, 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (13, '2026-06-11 00:17:14.116+02', 'Server startup', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 0, NULL, 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (14, '2026-06-11 00:17:17.285+02', 'Server startup complete', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 0, NULL, 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (15, '2026-06-11 00:19:10.873+02', 'Login', 'INFORMATION', 'FAILURE', '<map>
  <entry>
    <string>username</string>
    <string>admin</string>
  </entry>
</map>', 0, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (16, '2026-06-11 00:20:33.861+02', 'Login', 'INFORMATION', 'SUCCESS', '<map>
  <entry>
    <string>username</string>
    <string>admin</string>
  </entry>
</map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (17, '2026-06-11 00:20:36.695+02', 'Get resources', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (18, '2026-06-11 00:20:36.734+02', 'Get libraries invoked through Directory Resource', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>resourceId</string>
    <string>Default Resource
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (19, '2026-06-11 04:34:20.037+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string></string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (20, '2026-06-11 04:34:20.097+02', 'Create channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (21, '2026-06-11 04:34:38.09+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (22, '2026-06-11 04:38:04.65+02', 'Get channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (23, '2026-06-11 04:38:11.763+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (24, '2026-06-11 04:38:11.798+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T04:37:48+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (25, '2026-06-11 04:38:15.851+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (26, '2026-06-11 05:01:53.923+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (27, '2026-06-11 05:01:53.95+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T05:01:24+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (39, '2026-06-11 05:39:15.385+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T05:37:52+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (28, '2026-06-11 05:14:10.488+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=0,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (29, '2026-06-11 05:14:52.514+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=0,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (30, '2026-06-11 05:19:17.164+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=0,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (31, '2026-06-11 05:36:09.868+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=2,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (32, '2026-06-11 05:36:12.789+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>2
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (33, '2026-06-11 05:38:20.383+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (34, '2026-06-11 05:38:20.409+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T05:37:52+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (35, '2026-06-11 05:39:01.78+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (36, '2026-06-11 05:39:01.802+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T05:37:52+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (37, '2026-06-11 05:39:01.818+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T05:37:52+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>true
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (38, '2026-06-11 05:39:15.363+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (40, '2026-06-11 05:39:15.4+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T05:37:52+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>true
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (41, '2026-06-11 05:51:15.31+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=3,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (42, '2026-06-11 05:55:29.434+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (43, '2026-06-11 05:56:36.116+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=3,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (44, '2026-06-11 05:57:11.886+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (45, '2026-06-11 05:57:11.91+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T05:56:44+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (46, '2026-06-11 05:57:19.886+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (47, '2026-06-11 06:06:00.398+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=4,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (48, '2026-06-11 06:06:11.223+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=4,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (62, '2026-06-11 06:27:45.9+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>5
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (77, '2026-06-11 06:51:58.305+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>7
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (49, '2026-06-11 06:06:27.246+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=4,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (50, '2026-06-11 06:06:32.699+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>4
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (51, '2026-06-11 06:09:32.127+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=4,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (52, '2026-06-11 06:09:32.881+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>4
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (53, '2026-06-11 06:13:26.572+02', 'Remove all messages', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>clearStatistics</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>restartRunningChannels</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (54, '2026-06-11 06:13:26.573+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (55, '2026-06-11 06:14:04.296+02', 'Remove all messages', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>clearStatistics</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>restartRunningChannels</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (56, '2026-06-11 06:14:04.296+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (57, '2026-06-11 06:14:17.809+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channelConnectorMap</string>
    <string>{bc082c4b-db17-4e8f-9666-b96a1e9a9822=[null, 0, 1]}
</string>
  </entry>
  <entry>
    <string>filtered</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>received</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>error</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>sent</string>
    <string>true
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (58, '2026-06-11 06:15:40.226+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (59, '2026-06-11 06:15:40.25+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T06:15:31+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (60, '2026-06-11 06:15:58.861+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (61, '2026-06-11 06:27:44.308+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=5,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (63, '2026-06-11 06:34:39.529+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=5,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (64, '2026-06-11 06:40:03.777+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (65, '2026-06-11 06:40:03.803+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T06:34:44+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (66, '2026-06-11 06:40:29.607+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (67, '2026-06-11 06:40:38.72+02', 'Remove all messages', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>clearStatistics</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>restartRunningChannels</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (68, '2026-06-11 06:40:38.721+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (69, '2026-06-11 06:43:45.939+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=6,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (70, '2026-06-11 06:43:49.461+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>6
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (71, '2026-06-11 06:48:03.76+02', 'Get resources', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (72, '2026-06-11 06:48:15.39+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (73, '2026-06-11 06:48:15.412+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T06:47:37+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (74, '2026-06-11 06:48:17.453+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (75, '2026-06-11 06:48:27.173+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channelConnectorMap</string>
    <string>{bc082c4b-db17-4e8f-9666-b96a1e9a9822=[null, 0, 1]}
</string>
  </entry>
  <entry>
    <string>filtered</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>received</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>error</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>sent</string>
    <string>true
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (76, '2026-06-11 06:51:54.236+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=7,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (78, '2026-06-11 06:52:00.671+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>6
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (79, '2026-06-11 06:53:04.314+02', 'Remove all messages', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>clearStatistics</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>restartRunningChannels</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (80, '2026-06-11 06:53:04.315+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (81, '2026-06-11 07:05:24.145+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (82, '2026-06-11 07:05:24.189+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T06:54:27+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (83, '2026-06-11 07:05:27.423+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (84, '2026-06-11 07:05:36.082+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channelConnectorMap</string>
    <string>{bc082c4b-db17-4e8f-9666-b96a1e9a9822=[null, 0, 1]}
</string>
  </entry>
  <entry>
    <string>filtered</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>received</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>error</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>sent</string>
    <string>true
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (85, '2026-06-11 07:05:44.086+02', 'Remove all messages', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>clearStatistics</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>restartRunningChannels</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (86, '2026-06-11 07:05:44.086+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (87, '2026-06-11 07:05:49.71+02', 'Undeploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (88, '2026-06-11 07:05:55.862+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (89, '2026-06-11 07:13:41.802+02', 'Set user preferences', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>userId</string>
    <string>1
</string>
  </entry>
  <entry>
    <string>properties</string>
    <string>{showNotificationPopup=false}
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (90, '2026-06-11 07:13:52.25+02', 'Get resources', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (91, '2026-06-11 07:14:58.916+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (92, '2026-06-11 07:14:58.935+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T07:13:17+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (93, '2026-06-11 07:16:11.686+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=8,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (94, '2026-06-11 07:16:21.388+02', 'Get channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (95, '2026-06-11 07:19:09.729+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (96, '2026-06-11 07:19:09.751+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T07:16:14+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (97, '2026-06-11 07:19:12.789+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (98, '2026-06-11 07:19:23.246+02', 'Remove all messages', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>clearStatistics</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>restartRunningChannels</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (99, '2026-06-11 07:19:23.248+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (100, '2026-06-11 07:19:33.161+02', 'Stop channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (101, '2026-06-11 07:19:34.743+02', 'Undeploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (102, '2026-06-11 07:19:40.357+02', 'Get resources', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (103, '2026-06-11 07:19:58.223+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (104, '2026-06-11 07:21:05.736+02', 'Login', 'INFORMATION', 'FAILURE', '<map>
  <entry>
    <string>username</string>
    <string>admin</string>
  </entry>
</map>', 0, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (105, '2026-06-11 07:23:46.001+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=0,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (106, '2026-06-11 07:26:57.967+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=0,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (107, '2026-06-11 07:27:42.433+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (108, '2026-06-11 07:27:42.455+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T07:27:32+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (109, '2026-06-11 07:29:09.048+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (110, '2026-06-11 07:29:17.441+02', 'Remove all messages', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>clearStatistics</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>restartRunningChannels</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (111, '2026-06-11 07:29:17.441+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (112, '2026-06-11 07:30:26.934+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (113, '2026-06-11 07:30:26.956+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T07:29:57+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (114, '2026-06-11 07:30:29.854+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (115, '2026-06-11 07:37:54.891+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (116, '2026-06-11 07:37:54.914+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T07:35:23+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (117, '2026-06-11 07:42:04.433+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (118, '2026-06-11 07:42:04.453+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T07:35:23+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (119, '2026-06-11 07:42:04.465+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T07:35:23+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>true
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (120, '2026-06-11 07:42:08.593+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (121, '2026-06-11 07:42:17.864+02', 'Remove all messages', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>clearStatistics</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>restartRunningChannels</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (122, '2026-06-11 07:42:17.865+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (123, '2026-06-11 07:59:57.904+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=10,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (124, '2026-06-11 08:00:02.097+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>10
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (125, '2026-06-11 08:00:27.67+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=10,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (126, '2026-06-11 08:00:31.737+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>10
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (127, '2026-06-11 08:03:44.713+02', 'Undeploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (128, '2026-06-11 08:06:24.488+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (129, '2026-06-11 08:06:24.508+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T08:04:23+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (130, '2026-06-11 08:06:26.471+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (131, '2026-06-11 08:07:42.832+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=10,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (132, '2026-06-11 08:08:00.522+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>10
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (133, '2026-06-11 08:09:52.237+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (134, '2026-06-11 08:09:52.258+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T08:09:33+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (135, '2026-06-11 08:09:53.891+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (136, '2026-06-11 08:12:41.195+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (137, '2026-06-11 08:12:41.214+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T08:11:01+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (138, '2026-06-11 08:12:46.345+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (139, '2026-06-11 08:22:25.967+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (140, '2026-06-11 08:22:25.989+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T08:18:16+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (141, '2026-06-11 08:22:28.032+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (142, '2026-06-11 08:22:38.357+02', 'Remove all messages', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>clearStatistics</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>restartRunningChannels</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (143, '2026-06-11 08:22:38.357+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (144, '2026-06-11 08:26:52.677+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=12,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (145, '2026-06-11 08:26:53.996+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>12
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (146, '2026-06-11 08:35:08.321+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (147, '2026-06-11 08:35:08.342+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T08:34:47+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (148, '2026-06-11 08:35:10.565+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (149, '2026-06-11 08:35:19.071+02', 'Remove all messages', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>clearStatistics</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>restartRunningChannels</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (150, '2026-06-11 08:35:19.071+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (151, '2026-06-11 08:37:55.02+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=13,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (152, '2026-06-11 08:38:02.636+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>13
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (153, '2026-06-11 08:40:02.227+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (154, '2026-06-11 08:40:02.246+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T08:38:34+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (155, '2026-06-11 08:40:04.129+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (156, '2026-06-11 08:40:26.572+02', 'Remove all messages', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>clearStatistics</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>restartRunningChannels</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (157, '2026-06-11 08:40:26.573+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (158, '2026-06-11 08:42:12.731+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=14,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (159, '2026-06-11 08:42:18.358+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>14
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (160, '2026-06-11 08:45:23.229+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (161, '2026-06-11 08:45:23.249+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T08:45:10+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (162, '2026-06-11 08:45:25.279+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (163, '2026-06-11 08:45:38.26+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channelConnectorMap</string>
    <string>{bc082c4b-db17-4e8f-9666-b96a1e9a9822=[null, 0, 1]}
</string>
  </entry>
  <entry>
    <string>filtered</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>received</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>error</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>sent</string>
    <string>true
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (164, '2026-06-11 08:45:45.202+02', 'Remove all messages', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>clearStatistics</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>restartRunningChannels</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (165, '2026-06-11 08:45:45.202+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (166, '2026-06-11 08:51:43.314+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=15,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (167, '2026-06-11 08:51:45.701+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>15
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (168, '2026-06-11 09:04:13.468+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (169, '2026-06-11 09:04:21.829+02', 'Remove all messages', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>clearStatistics</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>restartRunningChannels</string>
    <string>true
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (170, '2026-06-11 09:04:21.83+02', 'Clear statistics', 'INFORMATION', 'SUCCESS', '<linked-hash-map/>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (171, '2026-06-11 09:17:07.474+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=16,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (172, '2026-06-11 09:17:11.824+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>16
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (173, '2026-06-11 09:21:53.503+02', 'Get channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (174, '2026-06-11 09:21:53.525+02', 'Update channel', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>startEdit</string>
    <string>2026-06-11T09:21:08+0200
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
  <entry>
    <string>override</string>
    <string>false
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (175, '2026-06-11 09:21:55.619+02', 'Deploy channels', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>returnErrors</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (176, '2026-06-11 09:26:13.397+02', 'Get messages by page limit', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>filter</string>
    <string>MessageFilter[
attachment=false,
contentSearch=&lt;null&gt;,
endDate=&lt;null&gt;,
error=false,
excludedMetaDataIds=&lt;null&gt;,
importIdLower=&lt;null&gt;,
importIdUpper=&lt;null&gt;,
includedMetaDataIds=&lt;null&gt;,
maxMessageId=17,
metaDataSearch=&lt;null&gt;,
minMessageId=&lt;null&gt;,
originalIdLower=&lt;null&gt;,
originalIdUpper=&lt;null&gt;,
sendAttemptsLower=&lt;null&gt;,
sendAttemptsUpper=&lt;null&gt;,
serverId=&lt;null&gt;,
startDate=&lt;null&gt;,
statuses=&lt;null&gt;,
textSearch=&lt;null&gt;,
textSearchMetaDataColumns=&lt;null&gt;,
textSearchRegex=&lt;null&gt;
]
</string>
  </entry>
  <entry>
    <string>includeContent</string>
    <string>false
</string>
  </entry>
  <entry>
    <string>offset</string>
    <string>0
</string>
  </entry>
  <entry>
    <string>limit</string>
    <string>21
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');
INSERT INTO public.event VALUES (177, '2026-06-11 09:26:14.912+02', 'Get message content', 'INFORMATION', 'SUCCESS', '<linked-hash-map>
  <entry>
    <string>metaDataIds</string>
    <string></string>
  </entry>
  <entry>
    <string>messageId</string>
    <string>17
</string>
  </entry>
  <entry>
    <string>channel</string>
    <string>Channel[id=bc082c4b-db17-4e8f-9666-b96a1e9a9822,name=FHIR_CheckIn_Receiver]
</string>
  </entry>
</linked-hash-map>', 1, '127.0.0.1', 'da6c2f58-f3c5-4ef7-aa2b-7bca29edf45a');


--
-- TOC entry 5158 (class 0 OID 16797)
-- Dependencies: 225
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.person VALUES (1, 'admin', 'Brijesh', 'Shivanna', 'Berner Fachhochschule', NULL, 'shivb1@bfh.ch', '', '', '2026-06-11 00:20:33.86+02', NULL, 1, '2026-06-11 07:21:05.734431+02', true, 'Other', 'Schweiz', NULL, false);


--
-- TOC entry 5160 (class 0 OID 16823)
-- Dependencies: 227
-- Data for Name: person_password; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.person_password VALUES (1, 'GwV2CbDiI837PhQ4MtuBw53YKUzBaC32hZDNZlRJO1Ehrf8qDwPd9A==
', '2026-06-10 21:21:34.192+02');


--
-- TOC entry 5159 (class 0 OID 16810)
-- Dependencies: 226
-- Data for Name: person_preference; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.person_preference VALUES (1, 'firstlogin', 'false');
INSERT INTO public.person_preference VALUES (1, 'checkForNotifications', 'true');
INSERT INTO public.person_preference VALUES (1, 'initialTagsChannels', '');
INSERT INTO public.person_preference VALUES (1, 'initialTagsDashboard', '');
INSERT INTO public.person_preference VALUES (1, 'showNotificationPopup', 'false');


--
-- TOC entry 5152 (class 0 OID 16761)
-- Dependencies: 219
-- Data for Name: schema_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schema_info VALUES ('4.5.2');


--
-- TOC entry 5156 (class 0 OID 16787)
-- Dependencies: 223
-- Data for Name: script; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 231
-- Name: configuration_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.configuration_sequence', 1, false);


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 243
-- Name: d_msq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.d_msq1', 17, true);


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 234
-- Name: debug_usage_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.debug_usage_sequence', 1, false);


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 220
-- Name: event_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.event_sequence', 177, true);


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 224
-- Name: person_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.person_sequence', 1, true);


--
-- TOC entry 4961 (class 2606 OID 16844)
-- Name: alert alert_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert
    ADD CONSTRAINT alert_name_key UNIQUE (name);


--
-- TOC entry 4963 (class 2606 OID 16842)
-- Name: alert alert_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert
    ADD CONSTRAINT alert_pkey PRIMARY KEY (id);


--
-- TOC entry 4973 (class 2606 OID 16885)
-- Name: channel_group channel_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel_group
    ADD CONSTRAINT channel_group_name_key UNIQUE (name);


--
-- TOC entry 4975 (class 2606 OID 16883)
-- Name: channel_group channel_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel_group
    ADD CONSTRAINT channel_group_pkey PRIMARY KEY (id);


--
-- TOC entry 4954 (class 2606 OID 16786)
-- Name: channel channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel
    ADD CONSTRAINT channel_pkey PRIMARY KEY (id);


--
-- TOC entry 4965 (class 2606 OID 16855)
-- Name: code_template_library code_template_library_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.code_template_library
    ADD CONSTRAINT code_template_library_name_key UNIQUE (name);


--
-- TOC entry 4967 (class 2606 OID 16853)
-- Name: code_template_library code_template_library_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.code_template_library
    ADD CONSTRAINT code_template_library_pkey PRIMARY KEY (id);


--
-- TOC entry 4969 (class 2606 OID 16864)
-- Name: code_template code_template_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.code_template
    ADD CONSTRAINT code_template_pkey PRIMARY KEY (id);


--
-- TOC entry 4971 (class 2606 OID 16874)
-- Name: configuration configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuration
    ADD CONSTRAINT configuration_pkey PRIMARY KEY (category, name);


--
-- TOC entry 4979 (class 2606 OID 16901)
-- Name: d_channels d_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.d_channels
    ADD CONSTRAINT d_channels_pkey PRIMARY KEY (local_channel_id);


--
-- TOC entry 4984 (class 2606 OID 16913)
-- Name: d_m1 d_m1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.d_m1
    ADD CONSTRAINT d_m1_pkey PRIMARY KEY (id);


--
-- TOC entry 4993 (class 2606 OID 16951)
-- Name: d_mc1 d_mc1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.d_mc1
    ADD CONSTRAINT d_mc1_pkey PRIMARY KEY (message_id, metadata_id, content_type);


--
-- TOC entry 4995 (class 2606 OID 16964)
-- Name: d_mcm1 d_mcm1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.d_mcm1
    ADD CONSTRAINT d_mcm1_pkey PRIMARY KEY (message_id, metadata_id);


--
-- TOC entry 4990 (class 2606 OID 16931)
-- Name: d_mm1 d_mm1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.d_mm1
    ADD CONSTRAINT d_mm1_pkey PRIMARY KEY (message_id, id);


--
-- TOC entry 4977 (class 2606 OID 16894)
-- Name: debugger_usage debugger_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.debugger_usage
    ADD CONSTRAINT debugger_usage_pkey PRIMARY KEY (id);


--
-- TOC entry 4952 (class 2606 OID 16777)
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- TOC entry 4958 (class 2606 OID 16809)
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- TOC entry 4956 (class 2606 OID 16795)
-- Name: script script_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.script
    ADD CONSTRAINT script_pkey PRIMARY KEY (group_id, id);


--
-- TOC entry 4981 (class 2606 OID 16903)
-- Name: d_channels unique_channel_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.d_channels
    ADD CONSTRAINT unique_channel_id UNIQUE (channel_id);


--
-- TOC entry 4982 (class 1259 OID 16914)
-- Name: d_m1_index1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX d_m1_index1 ON public.d_m1 USING btree (id, server_id);


--
-- TOC entry 4996 (class 1259 OID 16985)
-- Name: d_ma1_fki; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX d_ma1_fki ON public.d_ma1 USING btree (message_id);


--
-- TOC entry 4997 (class 1259 OID 16984)
-- Name: d_ma1_index1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX d_ma1_index1 ON public.d_ma1 USING btree (id);


--
-- TOC entry 4991 (class 1259 OID 16957)
-- Name: d_mc1_fki; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX d_mc1_fki ON public.d_mc1 USING btree (message_id, metadata_id);


--
-- TOC entry 4985 (class 1259 OID 16940)
-- Name: d_mm1_fki; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX d_mm1_fki ON public.d_mm1 USING btree (message_id);


--
-- TOC entry 4986 (class 1259 OID 16937)
-- Name: d_mm1_index1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX d_mm1_index1 ON public.d_mm1 USING btree (message_id, id, status);


--
-- TOC entry 4987 (class 1259 OID 16938)
-- Name: d_mm1_index2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX d_mm1_index2 ON public.d_mm1 USING btree (message_id, server_id, id);


--
-- TOC entry 4988 (class 1259 OID 16939)
-- Name: d_mm1_index3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX d_mm1_index3 ON public.d_mm1 USING btree (id, status, server_id);


--
-- TOC entry 4998 (class 1259 OID 17006)
-- Name: d_ms1_index1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX d_ms1_index1 ON public.d_ms1 USING btree (metadata_id, server_id);


--
-- TOC entry 4959 (class 1259 OID 16822)
-- Name: person_preference_index1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX person_preference_index1 ON public.person_preference USING btree (person_id);


--
-- TOC entry 5004 (class 2606 OID 16979)
-- Name: d_ma1 d_ma1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.d_ma1
    ADD CONSTRAINT d_ma1_fkey FOREIGN KEY (message_id) REFERENCES public.d_m1(id) ON DELETE CASCADE;


--
-- TOC entry 5002 (class 2606 OID 16952)
-- Name: d_mc1 d_mc1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.d_mc1
    ADD CONSTRAINT d_mc1_fkey FOREIGN KEY (message_id, metadata_id) REFERENCES public.d_mm1(message_id, id) ON DELETE CASCADE;


--
-- TOC entry 5003 (class 2606 OID 16965)
-- Name: d_mcm1 d_mcm1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.d_mcm1
    ADD CONSTRAINT d_mcm1_fkey FOREIGN KEY (message_id, metadata_id) REFERENCES public.d_mm1(message_id, id) ON DELETE CASCADE;


--
-- TOC entry 5001 (class 2606 OID 16932)
-- Name: d_mm1 d_mm1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.d_mm1
    ADD CONSTRAINT d_mm1_fkey FOREIGN KEY (message_id) REFERENCES public.d_m1(id) ON DELETE CASCADE;


--
-- TOC entry 5000 (class 2606 OID 16828)
-- Name: person_password person_password_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_password
    ADD CONSTRAINT person_password_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- TOC entry 4999 (class 2606 OID 16817)
-- Name: person_preference person_preference_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_preference
    ADD CONSTRAINT person_preference_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


-- Completed on 2026-06-11 09:44:39

--
-- PostgreSQL database dump complete
--

\unrestrict dGpOD1qbgpUc3Y1m1JBR6MXLjdL6ZBKBSrQFaaLaIFrOZuV7NQTA078jxtG1Bwa

