// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppConfigCollection on Isar {
  IsarCollection<AppConfig> get appConfigs => this.collection();
}

const AppConfigSchema = CollectionSchema(
  name: r'AppConfig',
  id: -7085420701237142207,
  properties: {
    r'dailyQuoteAuthor': PropertySchema(
      id: 0,
      name: r'dailyQuoteAuthor',
      type: IsarType.string,
    ),
    r'dailyQuoteText': PropertySchema(
      id: 1,
      name: r'dailyQuoteText',
      type: IsarType.string,
    ),
    r'lastBookmarkAnimDate': PropertySchema(
      id: 2,
      name: r'lastBookmarkAnimDate',
      type: IsarType.string,
    )
  },
  estimateSize: _appConfigEstimateSize,
  serialize: _appConfigSerialize,
  deserialize: _appConfigDeserialize,
  deserializeProp: _appConfigDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appConfigGetId,
  getLinks: _appConfigGetLinks,
  attach: _appConfigAttach,
  version: '3.1.0+1',
);

int _appConfigEstimateSize(
  AppConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.dailyQuoteAuthor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.dailyQuoteText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastBookmarkAnimDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _appConfigSerialize(
  AppConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.dailyQuoteAuthor);
  writer.writeString(offsets[1], object.dailyQuoteText);
  writer.writeString(offsets[2], object.lastBookmarkAnimDate);
}

AppConfig _appConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppConfig();
  object.dailyQuoteAuthor = reader.readStringOrNull(offsets[0]);
  object.dailyQuoteText = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.lastBookmarkAnimDate = reader.readStringOrNull(offsets[2]);
  return object;
}

P _appConfigDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appConfigGetId(AppConfig object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appConfigGetLinks(AppConfig object) {
  return [];
}

void _appConfigAttach(IsarCollection<dynamic> col, Id id, AppConfig object) {
  object.id = id;
}

extension AppConfigQueryWhereSort
    on QueryBuilder<AppConfig, AppConfig, QWhere> {
  QueryBuilder<AppConfig, AppConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppConfigQueryWhere
    on QueryBuilder<AppConfig, AppConfig, QWhereClause> {
  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppConfigQueryFilter
    on QueryBuilder<AppConfig, AppConfig, QFilterCondition> {
  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteAuthorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dailyQuoteAuthor',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteAuthorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dailyQuoteAuthor',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteAuthorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyQuoteAuthor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteAuthorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyQuoteAuthor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteAuthorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyQuoteAuthor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteAuthorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyQuoteAuthor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteAuthorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dailyQuoteAuthor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteAuthorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dailyQuoteAuthor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteAuthorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dailyQuoteAuthor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteAuthorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dailyQuoteAuthor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteAuthorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyQuoteAuthor',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteAuthorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dailyQuoteAuthor',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dailyQuoteText',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dailyQuoteText',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteTextEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyQuoteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteTextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyQuoteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteTextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyQuoteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteTextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyQuoteText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dailyQuoteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dailyQuoteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dailyQuoteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dailyQuoteText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyQuoteText',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      dailyQuoteTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dailyQuoteText',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      lastBookmarkAnimDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastBookmarkAnimDate',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      lastBookmarkAnimDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastBookmarkAnimDate',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      lastBookmarkAnimDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastBookmarkAnimDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      lastBookmarkAnimDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastBookmarkAnimDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      lastBookmarkAnimDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastBookmarkAnimDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      lastBookmarkAnimDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastBookmarkAnimDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      lastBookmarkAnimDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastBookmarkAnimDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      lastBookmarkAnimDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastBookmarkAnimDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      lastBookmarkAnimDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastBookmarkAnimDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      lastBookmarkAnimDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastBookmarkAnimDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      lastBookmarkAnimDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastBookmarkAnimDate',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      lastBookmarkAnimDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastBookmarkAnimDate',
        value: '',
      ));
    });
  }
}

extension AppConfigQueryObject
    on QueryBuilder<AppConfig, AppConfig, QFilterCondition> {}

extension AppConfigQueryLinks
    on QueryBuilder<AppConfig, AppConfig, QFilterCondition> {}

extension AppConfigQuerySortBy on QueryBuilder<AppConfig, AppConfig, QSortBy> {
  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByDailyQuoteAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuoteAuthor', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByDailyQuoteAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuoteAuthor', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByDailyQuoteText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuoteText', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByDailyQuoteTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuoteText', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByLastBookmarkAnimDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBookmarkAnimDate', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByLastBookmarkAnimDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBookmarkAnimDate', Sort.desc);
    });
  }
}

extension AppConfigQuerySortThenBy
    on QueryBuilder<AppConfig, AppConfig, QSortThenBy> {
  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByDailyQuoteAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuoteAuthor', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByDailyQuoteAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuoteAuthor', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByDailyQuoteText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuoteText', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByDailyQuoteTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuoteText', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByLastBookmarkAnimDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBookmarkAnimDate', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByLastBookmarkAnimDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBookmarkAnimDate', Sort.desc);
    });
  }
}

extension AppConfigQueryWhereDistinct
    on QueryBuilder<AppConfig, AppConfig, QDistinct> {
  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByDailyQuoteAuthor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyQuoteAuthor',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByDailyQuoteText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyQuoteText',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByLastBookmarkAnimDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastBookmarkAnimDate',
          caseSensitive: caseSensitive);
    });
  }
}

extension AppConfigQueryProperty
    on QueryBuilder<AppConfig, AppConfig, QQueryProperty> {
  QueryBuilder<AppConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppConfig, String?, QQueryOperations>
      dailyQuoteAuthorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyQuoteAuthor');
    });
  }

  QueryBuilder<AppConfig, String?, QQueryOperations> dailyQuoteTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyQuoteText');
    });
  }

  QueryBuilder<AppConfig, String?, QQueryOperations>
      lastBookmarkAnimDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastBookmarkAnimDate');
    });
  }
}
