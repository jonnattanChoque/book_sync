// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_streak.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserStreakCollection on Isar {
  IsarCollection<UserStreak> get userStreaks => this.collection();
}

const UserStreakSchema = CollectionSchema(
  name: r'UserStreak',
  id: 4740986671101977218,
  properties: {
    r'bestStreak': PropertySchema(
      id: 0,
      name: r'bestStreak',
      type: IsarType.long,
    ),
    r'currentStreak': PropertySchema(
      id: 1,
      name: r'currentStreak',
      type: IsarType.long,
    ),
    r'lastReadingDate': PropertySchema(
      id: 2,
      name: r'lastReadingDate',
      type: IsarType.dateTime,
    ),
    r'readingDays': PropertySchema(
      id: 3,
      name: r'readingDays',
      type: IsarType.dateTimeList,
    )
  },
  estimateSize: _userStreakEstimateSize,
  serialize: _userStreakSerialize,
  deserialize: _userStreakDeserialize,
  deserializeProp: _userStreakDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userStreakGetId,
  getLinks: _userStreakGetLinks,
  attach: _userStreakAttach,
  version: '3.1.0+1',
);

int _userStreakEstimateSize(
  UserStreak object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.readingDays.length * 8;
  return bytesCount;
}

void _userStreakSerialize(
  UserStreak object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bestStreak);
  writer.writeLong(offsets[1], object.currentStreak);
  writer.writeDateTime(offsets[2], object.lastReadingDate);
  writer.writeDateTimeList(offsets[3], object.readingDays);
}

UserStreak _userStreakDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserStreak();
  object.bestStreak = reader.readLong(offsets[0]);
  object.currentStreak = reader.readLong(offsets[1]);
  object.id = id;
  object.lastReadingDate = reader.readDateTimeOrNull(offsets[2]);
  object.readingDays = reader.readDateTimeList(offsets[3]) ?? [];
  return object;
}

P _userStreakDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userStreakGetId(UserStreak object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userStreakGetLinks(UserStreak object) {
  return [];
}

void _userStreakAttach(IsarCollection<dynamic> col, Id id, UserStreak object) {
  object.id = id;
}

extension UserStreakQueryWhereSort
    on QueryBuilder<UserStreak, UserStreak, QWhere> {
  QueryBuilder<UserStreak, UserStreak, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserStreakQueryWhere
    on QueryBuilder<UserStreak, UserStreak, QWhereClause> {
  QueryBuilder<UserStreak, UserStreak, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<UserStreak, UserStreak, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterWhereClause> idBetween(
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

extension UserStreakQueryFilter
    on QueryBuilder<UserStreak, UserStreak, QFilterCondition> {
  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition> bestStreakEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      bestStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      bestStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition> bestStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bestStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      currentStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      currentStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      currentStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      currentStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      lastReadingDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastReadingDate',
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      lastReadingDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastReadingDate',
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      lastReadingDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      lastReadingDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      lastReadingDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      lastReadingDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadingDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      readingDaysElementEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readingDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      readingDaysElementGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'readingDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      readingDaysElementLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'readingDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      readingDaysElementBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'readingDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      readingDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'readingDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      readingDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'readingDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      readingDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'readingDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      readingDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'readingDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      readingDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'readingDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterFilterCondition>
      readingDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'readingDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension UserStreakQueryObject
    on QueryBuilder<UserStreak, UserStreak, QFilterCondition> {}

extension UserStreakQueryLinks
    on QueryBuilder<UserStreak, UserStreak, QFilterCondition> {}

extension UserStreakQuerySortBy
    on QueryBuilder<UserStreak, UserStreak, QSortBy> {
  QueryBuilder<UserStreak, UserStreak, QAfterSortBy> sortByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.asc);
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterSortBy> sortByBestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.desc);
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterSortBy> sortByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterSortBy> sortByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterSortBy> sortByLastReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadingDate', Sort.asc);
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterSortBy>
      sortByLastReadingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadingDate', Sort.desc);
    });
  }
}

extension UserStreakQuerySortThenBy
    on QueryBuilder<UserStreak, UserStreak, QSortThenBy> {
  QueryBuilder<UserStreak, UserStreak, QAfterSortBy> thenByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.asc);
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterSortBy> thenByBestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.desc);
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterSortBy> thenByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterSortBy> thenByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterSortBy> thenByLastReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadingDate', Sort.asc);
    });
  }

  QueryBuilder<UserStreak, UserStreak, QAfterSortBy>
      thenByLastReadingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadingDate', Sort.desc);
    });
  }
}

extension UserStreakQueryWhereDistinct
    on QueryBuilder<UserStreak, UserStreak, QDistinct> {
  QueryBuilder<UserStreak, UserStreak, QDistinct> distinctByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bestStreak');
    });
  }

  QueryBuilder<UserStreak, UserStreak, QDistinct> distinctByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreak');
    });
  }

  QueryBuilder<UserStreak, UserStreak, QDistinct> distinctByLastReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadingDate');
    });
  }

  QueryBuilder<UserStreak, UserStreak, QDistinct> distinctByReadingDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readingDays');
    });
  }
}

extension UserStreakQueryProperty
    on QueryBuilder<UserStreak, UserStreak, QQueryProperty> {
  QueryBuilder<UserStreak, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserStreak, int, QQueryOperations> bestStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bestStreak');
    });
  }

  QueryBuilder<UserStreak, int, QQueryOperations> currentStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreak');
    });
  }

  QueryBuilder<UserStreak, DateTime?, QQueryOperations>
      lastReadingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadingDate');
    });
  }

  QueryBuilder<UserStreak, List<DateTime>, QQueryOperations>
      readingDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readingDays');
    });
  }
}
