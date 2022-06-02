public interface IDataProvider {
    List<CoCData> searchByTerm(String searchTerm);
    CoCProfile getProfile(String identifier, Boolean isBranch, Boolean isMainBranch);
}